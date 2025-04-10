using Microsoft.ML.OnnxRuntime;
using Microsoft.Win32;
using System;
using Microsoft.ML.OnnxRuntime.Tensors;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Globalization;
using static RealEstatePriceForecast.MainWindow;
using static System.Collections.Specialized.BitVector32;

namespace RealEstatePriceForecast
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private PredictionsEntities _context = new PredictionsEntities();
        public MainWindow()
        {
            SetWebBrowserFeatureControl();
            InitializeComponent();
            this.Loaded += MainWindow_Loaded;
            comboMetroStation.ItemsSource = _context.MetroStations.ToList();
        }

        private void SetWebBrowserFeatureControl()
        {
            string appName = Process.GetCurrentProcess().ProcessName + ".exe";
            using (var key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION"))
            {
                key.SetValue(appName, 11001, RegistryValueKind.DWord); 
            }
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            PropertyPriceSlider.Value = 3000000; 
            DownPaymentSlider.Value = 600000;
            DownPaymentSlider.Maximum = PropertyPriceSlider.Value;
            LoanTermSlider.Value = 20;
            InterestRateSlider.Value = 8;
            UpdateCalculations();
        }

        private void cmbMetroStations_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (comboMetroStation.SelectedItem == null) return;

            var selectedStation = (MetroStations)comboMetroStation.SelectedItem;

            txtLatitude.Text = selectedStation.Latitude.ToString("F6");
            txtLongitude.Text = selectedStation.Longitude.ToString("F6");
        }
        
        public class MetroStation
        {
            public string Name { get; }
            public float Latitude { get; }
            public float Longitude { get; }

            public MetroStation(string name, float lat, float lon)
            {
                Name = name;
                Latitude = lat;
                Longitude = lon;
            }

            public override string ToString() => Name; 
        }

        private void btnPredict_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (!float.TryParse(txtMinutesToMetro.Text, out float minutesToMetro) ||
                    !float.TryParse(txtRooms.Text, out float rooms) ||
                    !float.TryParse(txtArea.Text, out float area) ||
                    !float.TryParse(txtLivingArea.Text, out float livingArea) ||
                    !float.TryParse(txtKitchenArea.Text, out float kitchenArea) ||
                    !float.TryParse(txtFloor.Text, out float floor) ||
                    !float.TryParse(txtTotalFloors.Text, out float totalFloors) ||
                    !float.TryParse(txtLatitude.Text, out float latitude) ||
                    !float.TryParse(txtLongitude.Text, out float longitude))
                {
                    MessageBox.Show("Некорректный ввод! Убедитесь, что все поля содержат числа.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (floor > totalFloors)
                {
                    MessageBox.Show("Этаж не может быть больше количества этажей в доме.", "Ошибка логики", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (kitchenArea > area || livingArea > area)
                {
                    MessageBox.Show("Площадь кухни или жилая площадь не могут быть больше общей площади.", "Ошибка логики", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (area <= 0 || livingArea <= 0 || kitchenArea <= 0)
                {
                    MessageBox.Show("Площадь не может быть нулевой или отрицательной.", "Ошибка логики", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var selectedMetro = (MetroStations)comboMetroStation.SelectedItem;

                float regionMoscow = 1;
                float regionMoscowRegion = 0;
                float aptNew = chkNewBuilding.IsChecked == true ? 1 : 0;
                float aptSecondary = chkSecondary.IsChecked == true ? 1 : 0;
                float renoCosmetic = chkRenovationCosmetic.IsChecked == true ? 1 : 0;
                float renoDesigner = chkRenovationDesigner.IsChecked == true ? 1 : 0;
                float renoEuro = chkRenovationEuro.IsChecked == true ? 1 : 0;
                float renoNone = chkRenovationNone.IsChecked == true ? 1 : 0;

                if (aptNew + aptSecondary != 1 ||
                    renoCosmetic + renoDesigner + renoEuro + renoNone != 1)
                {
                    MessageBox.Show("Выберите корректное количество опций: один регион, один тип квартиры, один тип ремонта.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                // Формируем массив входных данных
                float[] input = {
                minutesToMetro, rooms, area, livingArea, kitchenArea, floor, totalFloors,
                regionMoscow, regionMoscowRegion,
                aptNew, aptSecondary,
                renoCosmetic, renoDesigner, renoEuro, renoNone,
                latitude, longitude
                };

                float predictedPrice = PredictPrice(input);

                if (predictedPrice > 0)
                {
                    txtResult.Text = $"{predictedPrice:0,0} руб.";
                }
                else
                {
                    txtResult.Text = "Ошибка при предсказании.";
                    return;
                }

                // Прогноз на 5 и 10 лет
                double growthRate = 0.05;
                double priceIn5Years = predictedPrice * Math.Pow(1 + growthRate, 5);
                double priceIn10Years = predictedPrice * Math.Pow(1 + growthRate, 10);

                txtPriceIn5Years.Text = $"{priceIn5Years:N0} руб.";
                txtPriceIn10Years.Text = $"{priceIn10Years:N0} руб.";

                int? apartmentTypeId = _context.ApartmentTypes
                .Where(at =>
                    (chkNewBuilding.IsChecked == true && at.Name == "Новостройка") ||
                    (chkSecondary.IsChecked == true && at.Name == "Вторичка"))
                .Select(at => (int?)at.ApartmentTypeID) 
                .FirstOrDefault();

                int? renovationTypeId = _context.Renovations
                .Where(at =>
                    (chkRenovationCosmetic.IsChecked == true && at.Name == "Косметический") ||
                    (chkRenovationDesigner.IsChecked == true && at.Name == "Дизайнерский") ||
                    (chkRenovationEuro.IsChecked == true && at.Name == "Евроремонт") ||
                    (chkRenovationNone.IsChecked == true && at.Name == "Без ремонта"))
                .Select(at => (int?)at.RenovationID) 
                .FirstOrDefault();

                var realEstate = new RealEstate
                {
                    Rooms = (int)rooms,
                    TotalArea = (decimal)area,
                    LivingArea = (decimal)livingArea,
                    KitchenArea = (decimal)kitchenArea,
                    Floor = (int)floor,
                    TotalFloors = (int)totalFloors,
                    MetroStationID = selectedMetro.MetroStationID,
                    ApartmentTypeID = (int)apartmentTypeId,
                    RenovationID = (int)renovationTypeId
                };

                _context.RealEstate.Add(realEstate);
                _context.SaveChanges();

                var pricePrediction = new PricePredictions
                {
                    RealEstateID = realEstate.RealEstateID,
                    CurrentPrice = (decimal)predictedPrice,
                    PriceIn5Years = (decimal)priceIn5Years,
                    PriceIn10Years = (decimal)priceIn10Years
                };

                _context.PricePredictions.Add(pricePrediction);
                _context.SaveChanges();

                MessageBox.Show("Данные успешно сохранены в базе!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка: {ex.Message}", "Исключение", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private float PredictPrice(float[] input)
        {
            try
            {
                // Используем ваш код для предсказания
                var predictor = new PricePredictor("price_prediction_optimized.onnx");
                float predictedPrice = predictor.Predict(input);

                return predictedPrice;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при предсказании: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            return -1;
        }

        private void UpdateCalculations()
        {
            if (PropertyPriceSlider == null || DownPaymentSlider == null ||
                LoanTermSlider == null || InterestRateSlider == null ||
                MonthlyPaymentTextBlock == null || LoanAmountTextBlock == null ||
                TotalInterestTextBlock == null || TotalPaymentTextBlock == null ||
                RequiredIncomeTextBlock == null)
            {
                return;
            }

            try
            {
                double propertyPrice = PropertyPriceSlider.Value;
                double downPayment = DownPaymentSlider.Value;
                double loanTermYears = LoanTermSlider.Value;
                double annualInterestRate = InterestRateSlider.Value;

                if (downPayment > propertyPrice)
                {
                    MessageBox.Show("Первоначальный взнос не может превышать стоимость недвижимости!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                    DownPaymentSlider.Value = propertyPrice * 0.3;
                    return;
                }

                double loanAmount = propertyPrice - downPayment;
                double monthlyInterestRate = (annualInterestRate / 100) / 12;
                double numberOfPayments = loanTermYears * 12;

                double monthlyPayment = (loanAmount * monthlyInterestRate) /
                    (1 - Math.Pow(1 + monthlyInterestRate, -numberOfPayments));

                double totalInterest = (monthlyPayment * numberOfPayments) - loanAmount;
                double totalPayment = loanAmount + totalInterest;
                double requiredIncome = monthlyPayment * 2.5;

                MonthlyPaymentTextBlock.Text = $"Ежемесячный платёж: {monthlyPayment:N0} ₽";
                LoanAmountTextBlock.Text = $"Кредит: {loanAmount:N0} ₽";
                TotalInterestTextBlock.Text = $"Проценты: {totalInterest:N0} ₽";
                TotalPaymentTextBlock.Text = $"Общая выплата: {totalPayment:N0} ₽";
                RequiredIncomeTextBlock.Text = $"Необходимый доход: {requiredIncome:N0} ₽";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка в расчётах: " + ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void PropertyPriceSlider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            PropertyPriceTextBox.Text = PropertyPriceSlider.Value.ToString("N0");
            if (DownPaymentSlider != null && PropertyPriceSlider != null)
            {
                DownPaymentSlider.Maximum = PropertyPriceSlider.Value;
            }

            UpdateCalculations();
        }

        private void PropertyPriceTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (double.TryParse(PropertyPriceTextBox.Text, out double value))
                PropertyPriceSlider.Value = value;
        }

        private void DownPaymentSlider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            DownPaymentTextBox.Text = DownPaymentSlider.Value.ToString("N0");
            UpdateCalculations();
        }

        private void DownPaymentTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (double.TryParse(DownPaymentTextBox.Text, out double value))
                DownPaymentSlider.Value = value;
        }

        private void LoanTermSlider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            LoanTermTextBox.Text = LoanTermSlider.Value.ToString("N0");
            UpdateCalculations();
        }

        private void LoanTermTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (double.TryParse(LoanTermTextBox.Text, out double value))
                LoanTermSlider.Value = value;
        }

        private void InterestRateSlider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            InterestRateTextBox.Text = InterestRateSlider.Value.ToString("N1");
            UpdateCalculations();
        }

        private void InterestRateTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (double.TryParse(InterestRateTextBox.Text, out double value))
                InterestRateSlider.Value = value;
        }

        private void OSMMapBrowser_Loaded(object sender, RoutedEventArgs e)
        {
            string htmlContent = @"
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset='utf-8'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <script src='https://unpkg.com/leaflet@1.9.3/dist/leaflet.js'></script>
                <link rel='stylesheet' href='https://unpkg.com/leaflet@1.9.3/dist/leaflet.css'/>
                <style>
                    #map { width: 100%; height: 100vh; }
                </style>
            </head>
            <body>
                <div id='map'></div>
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        var map = L.map('map').setView([55.751244, 37.618423], 12);
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; OpenStreetMap contributors'
                        }).addTo(map);

                        function getColor(price) {
                            return price > 550000 ? '#800026' :
                                   price > 500000 ? '#BD0026' :
                                   price > 450000 ? '#E31A1C' :
                                   price > 400000 ? '#FC4E2A' :
                                   price > 350000 ? '#FD8D3C' :
                                   price > 300000 ? '#FEB24C' :
                                   price > 250000 ? '#FED976' :
                                                    '#FFEDA0';
                        }

                        var districts = [
                            { name: 'Остоженка', price: 576061, coords: [55.740867, 37.598061] },
                            { name: 'Центр', price: 534405, coords: [55.751956, 37.616959] },
                            { name: 'Арбат', price: 518741, coords: [55.749486, 37.591494] },
                            { name: 'Тверской', price: 492487, coords: [55.764460, 37.605948] },
                            { name: 'Якиманка', price: 476478, coords: [55.730831, 37.607574] },
                            { name: 'Хамовники', price: 468377, coords: [55.729199, 37.574534] },
                            { name: 'Пресненский', price: 419689, coords: [55.763437, 37.562389] },
                            { name: 'Красносельский', price: 409019, coords: [55.781696, 37.663072] },
                            { name: 'Мещанский', price: 407336, coords: [55.780071, 37.628801] },
                            { name: 'Беговой', price: 404868, coords: [55.782871, 37.566306] },
                            { name: 'Замоскворечье', price: 404800, coords: [55.734162, 37.634290] },
                            { name: 'Таганский', price: 392372, coords: [55.740010, 37.666971] },
                            { name: 'Дорогомилово', price: 388579, coords: [55.741617, 37.551277] },
                            { name: 'Донской', price: 375192, coords: [55.741617, 37.551277] },
                            { name: 'Гагаринский', price: 372811, coords: [55.698046, 37.558544] },
                            { name: 'Филевский парк', price: 341923, coords: [55.749805, 37.494593] },
                            { name: 'Алексеевский', price: 337283, coords: [55.749805, 37.494593] },
                            { name: 'Аэропорт', price: 333603, coords: [55.801076, 37.543749] },
                            { name: 'Проспект Вернадского', price: 333332, coords: [55.678407, 37.498635] },
                            { name: 'Басманный', price: 332179, coords: [55.766572, 37.671238] },
                            { name: 'Хорошевский', price: 331391, coords: [55.782294, 37.528208] },
                            { name: 'Динамо', price: 329242, coords: [55.801076, 37.543749] },
                            { name: 'Хорошево-Мневники', price: 322043, coords: [55.778011, 37.473995] },
                            { name: 'Академический', price: 321229, coords: [55.688365, 37.579601] },
                            { name: 'Марьина роща', price: 319611, coords: [55.796936, 37.614383] },
                            { name: 'Савеловский', price: 319611, coords: [55.799699, 37.570923] },
                            { name: 'Сокольники', price: 316042, coords: [55.799947, 37.677167] },
                            { name: 'Черемушки', price: 313221, coords: [55.664649, 37.561347] },
                            { name: 'Южнопортовый', price: 305504, coords: [55.717340, 37.671211] },
                            { name: 'Крылатское', price: 301332, coords: [55.759461, 37.407726] },
                            { name: 'Волгоградский проспект', price: 300765, coords: [55.717340, 37.671211] },
                            { name: 'Даниловский, Котловка', price: 290924, coords: [55.710631, 37.622989] },
                            { name: 'Можайский, Фили-Давыдково', price: 289251, coords: [55.717639, 37.422764] },
                            { name: 'Тропарево-Никулино', price: 289104, coords: [55.660323, 37.468497] },
                            { name: 'Останкинский', price: 288984, coords: [55.819080, 37.621714] },
                            { name: 'Ростокино', price: 288984, coords: [55.837717, 37.651547] },
                            { name: 'Очаково-Матвеевское', price: 288787, coords: [55.689654, 37.448563] },
                            { name: 'Бутырский', price: 287975, coords: [55.814128, 37.589213] },
                            { name: 'Тимирязевский', price: 287975, coords: [55.822003, 37.555274] },
                            { name: 'Кунцево', price: 286365, coords: [55.739341, 37.403378] },
                            { name: 'Измайлово', price: 285872, coords: [55.795373, 37.785494] },
                            { name: 'Покровское-Стрешнево', price: 282868, coords: [55.822680, 37.442590] },
                            { name: 'Щукино', price: 282868, coords: [55.800595, 37.473519] },
                            { name: 'Преображенское', price: 281678, coords: [55.797736, 37.725173] },
                            { name: 'Нагатино-Садовники', price: 280827, coords: [55.671422, 37.641719] },
                            { name: 'Нагатинский Затон', price: 280827, coords: [55.682849, 37.681577] },
                            { name: 'Свиблово', price: 276656, coords: [55.851091, 37.649615] },
                            { name: 'Войковский', price: 273259, coords: [55.827247, 37.497342] },
                            { name: 'Коптево', price: 273259, coords: [55.831216, 37.526286] },
                            { name: 'Зюзино', price: 272750, coords: [55.654066, 37.589608] },
                            { name: 'Нагорный', price: 272750, coords: [55.664665, 37.615470] },
                            { name: 'Лефортово', price: 269707, coords: [55.753635, 37.704826] },
                            { name: 'Соколиная гора', price: 269707, coords: [55.772780, 37.730625] },
                            { name: 'Коньково', price: 267943, coords: [55.644348, 37.529654] },
                            { name: 'Обручевский', price: 267943, coords: [55.660917, 37.518479] },
                            { name: 'Левобережный', price: 267355, coords: [55.893697, 37.475854] },
                            { name: 'Ховрино', price: 267355, coords: [55.869046, 37.489491] },
                            { name: 'Строгино', price: 266599, coords: [55.803788, 37.402695] },
                            { name: 'Куркино', price: 266525, coords: [55.891209, 37.387379] },
                            { name: 'Молжаниновский', price: 266525, coords: [55.936812, 37.380237] },
                            { name: 'Головинский', price: 261155, coords: [55.846765, 37.510610] },
                            { name: 'Чертаново Северное', price: 257662, coords: [55.632210, 37.605113] },
                            { name: 'Чертаново Центральное', price: 257662, coords: [55.613880, 37.604098] },
                            { name: 'Бабушкинский', price: 257193, coords: [55.867086, 37.665821] },
                            { name: 'Южное Медведково', price: 257193, coords: [55.871248, 37.637398] },
                            { name: 'Марфино', price: 255219, coords: [55.830007, 37.588745] },
                            { name: 'Печатники', price: 254844, coords: [55.685158, 37.723807] },
                            { name: 'Богородское', price: 252580, coords: [55.814087, 37.712282] },
                            { name: 'Метрогородок', price: 252580, coords: [55.823616, 37.755841] },
                            { name: 'Митино', price: 248718, coords: [55.845375, 37.365837] },
                            { name: 'Северное Тушино', price: 247677, coords: [55.858382, 37.431441] },
                            { name: 'Южное Тушино', price: 247677, coords: [55.843434, 37.431432] },
                            { name: 'Северное Медведково', price: 243968, coords: [55.888336, 37.655634] },
                            { name: 'Измайлово', price: 243754, coords: [55.795373, 37.785494] },
                            { name: 'Восточное Измайлово', price: 243754, coords: [55.795818, 37.821804] },
                            { name: 'Кузьминки', price: 242594, coords: [55.698645, 37.773556] },
                            { name: 'Текстильщики', price: 242594, coords: [55.708810, 37.737444] },
                            { name: 'Бескудниковский', price: 241962, coords: [55.866627, 37.554717] },
                            { name: 'Восточное Дегунино', price: 241962, coords: [55.884282, 37.558841] },
                            { name: 'Дмитровский', price: 241962, coords: [55.891032, 37.528639] },
                            { name: 'Западное Дегунино', price: 241962, coords: [55.872157, 37.518937] },
                            { name: 'Северный', price: 241962, coords: [55.929762, 37.546704] },
                            { name: 'Перово', price: 240848, coords: [55.751999, 37.767456] },
                            { name: 'Орехово-Борисово Северное', price: 240027, coords: [55.618278, 37.704817] },
                            { name: 'Орехово-Борисово Южное', price: 240027, coords: [55.604071, 37.738584] },
                            { name: 'Солнцево', price: 240020, coords: [55.645918, 37.401680] },
                            { name: 'Москворечье-Сабурово', price: 239446, coords: [55.642697, 37.671148] },
                            { name: 'Царицыно', price: 239446, coords: [55.629155, 37.662650] },
                            { name: 'Нижегородский', price: 239446, coords: [55.728429, 37.723816] },
                            { name: 'Рязанский', price: 239446, coords: [55.724718, 37.767600] },
                            { name: 'Северное Бутово', price: 237273, coords: [55.568919, 37.570528] },
                            { name: 'Чертаново Южное', price: 237266, coords: [55.591889, 37.600370] },
                            { name: 'Отрадное', price: 236840, coords: [55.863212, 37.604771] },
                            { name: 'Ясенево', price: 234904, coords: [55.607519, 37.534577] },
                            { name: 'Внуково', price: 234720, coords: [55.612273, 37.299542] },
                            { name: 'Ново-Переделкино', price: 234720, coords: [55.646086, 37.357169] },
                            { name: 'Лианозово', price: 233483, coords: [55.898487, 37.570016] },
                            { name: 'Братеево', price: 231149, coords: [55.633434, 37.765067] },
                            { name: 'Зябликово', price: 231149, coords: [55.620113, 37.748484] },
                            { name: 'Капотня', price: 230035, coords: [55.637840, 37.799724] },
                            { name: 'Марьино', price: 230035, coords: [55.652669, 37.744774] },
                            { name: 'Теплый Стан', price: 228467, coords: [55.631427, 37.489886] },
                            { name: 'Алтуфьевский', price: 228295, coords: [55.879854, 37.582278] },
                            { name: 'Бибирево', price: 228295, coords: [55.894495, 37.607673] },
                            { name: 'Восточный', price: 228024, coords: [55.817952, 37.862085] },
                            { name: 'Гольяново', price: 228024, coords: [55.816819, 37.798242] },
                            { name: 'Северное Измайлово', price: 228024, coords: [55.806849, 37.805230] },
                            { name: 'Лосиноостровский', price: 224409, coords: [55.881273, 37.694199] },
                            { name: 'Ярославский', price: 224409, coords: [55.862858, 37.697469] },
                            { name: 'Ивановское', price: 222255, coords: [55.767372, 37.832701] },
                            { name: 'Новогиреево', price: 222255, coords: [55.748154, 37.804117] },
                            { name: 'Новокосино', price: 222178, coords: [55.742205, 37.865804] },
                            { name: 'Люблино', price: 220210, coords: [55.676301, 37.763081] },
                            { name: 'Вешняки', price: 219912, coords: [55.730776, 37.815193] },
                            { name: 'Выхино-Жулебино', price: 219912, coords: [55.696362, 37.824553] },
                            { name: 'Южное Бутово', price: 218765, coords: [55.542625, 37.529573] },
                            { name: 'Жулебино', price: 211664, coords: [55.684924, 37.855267] },
                            { name: 'Кожухово', price: 211664, coords: [55.716767, 37.898116] },
                            { name: 'Косино-Ухтомский', price: 211664, coords: [55.713892, 37.876413] },
                            { name: 'Некрасовка', price: 211664, coords: [55.698158, 37.940094] },
                            { name: 'Бирюлево Восточное', price: 205820, coords: [55.594591, 37.678649] },
                            { name: 'Бирюлево Западное', price: 205820, coords: [55.587926, 37.637111] },
                            { name: 'Зеленоград', price: 196392, coords: [55.991893, 37.214390] }
                        ];

                        districts.forEach(function(district) {
                            L.circleMarker(district.coords, {
                                radius: 8,
                                color: getColor(district.price),
                                fillColor: getColor(district.price),
                                fillOpacity: 0.8
                            }).addTo(map).bindPopup(district.name + ': ' + district.price.toLocaleString() + ' ₽/м²');
                        });
                    });
                </script>
            </body>
            </html>";

            OSMMapBrowser.NavigateToString(htmlContent);
        }
    }

    public class PricePredictor
    {
        private readonly InferenceSession _session;

        public PricePredictor(string modelPath)
        {
            _session = new InferenceSession(modelPath);
        }

        public float Predict(float[] inputFeatures)
        {
            try
            {
                if (inputFeatures.Length != 17)
                {
                    throw new ArgumentException("Модель ожидает 17 входных параметров.");
                }

                var inputTensor = new DenseTensor<float>(inputFeatures, new int[] { 1, inputFeatures.Length });

                var inputs = new List<NamedOnnxValue>
            {
                NamedOnnxValue.CreateFromTensor("input", inputTensor)
            };

                using (var results = _session.Run(inputs))
                {
                    var output = results.First().AsEnumerable<float>().ToArray();
                    return (float)Math.Exp(output[0])/10; 
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при предсказании: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return -1;
            }
        }
    }

}
