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
        public MainWindow()
        {
            SetWebBrowserFeatureControl();
            InitializeComponent();
            this.Loaded += MainWindow_Loaded;
     
        }

        private void SetWebBrowserFeatureControl()
        {
            string appName = Process.GetCurrentProcess().ProcessName + ".exe";
            using (var key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION"))
            {
                key.SetValue(appName, 11001, RegistryValueKind.DWord); // Используем режим IE11
            }
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            PropertyPriceSlider.Value = 3000000; // Устанавливаем стартовые значения
            DownPaymentSlider.Value = 600000;
            DownPaymentSlider.Maximum = PropertyPriceSlider.Value;
            LoanTermSlider.Value = 20;
            InterestRateSlider.Value = 8;
            UpdateCalculations();


            foreach (string line in File.ReadAllLines("metro_converted.csv"))
            {
                // Разбиваем строку по точке с запятой
                string[] parts = line.Split(';');

                // Проверяем, что строка содержит 3 части (название, широта, долгота)
                if (parts.Length >= 3)
                {
                    try
                    {
                        // Очищаем данные от лишних пробелов и кавычек
                        string name = parts[0].Trim().Trim('"');
                        string latStr = parts[1].Trim().Trim('"');
                        string lonStr = parts[2].Trim().Trim('"');

                        // Парсим координаты с учетом культуры (для правильного чтения float)
                        float latitude = float.Parse(latStr, CultureInfo.InvariantCulture);
                        float longitude = float.Parse(lonStr, CultureInfo.InvariantCulture);

                        // Добавляем станцию в ComboBox
                        cmbMetroStations.Items.Add(new MetroStation(name, latitude, longitude));
                    }
                    catch (Exception ex) when (ex is FormatException || ex is IndexOutOfRangeException)
                    {
                        // Логируем ошибку без прерывания работы
                        Debug.WriteLine($"Ошибка в строке: {line}\n{ex.Message}");
                    }
                }
            }

        }

        // Обновляем широту и долготу в отдельных TextBlock при выборе станции
        private void cmbMetroStations_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (cmbMetroStations.SelectedItem is MetroStation station)
            {
                txtLatitude.Text = station.Latitude.ToString("F6");
                txtLongitude.Text = station.Longitude.ToString("F6");
            }
        }
        // Класс для хранения информации о станциях метро
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

            public override string ToString() => Name; // Отображение в ComboBox
        }

        private void btnPredict_Click(object sender, RoutedEventArgs e)
        {
            // Проверяем ввод и преобразуем строки в float
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
                MessageBox.Show("Некорректный ввод! Проверьте, что все поля содержат числа.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // Проверяем, что значения в допустимых пределах
            if (area <= 0 || rooms <= 0 || floor <= 0 || minutesToMetro < 0)
            {
                MessageBox.Show("Некорректные значения! Проверьте вводимые данные.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // Формируем массив входных данных
            float[] input = { minutesToMetro, rooms, area, livingArea, kitchenArea, floor, totalFloors, latitude, longitude };

            // Вызываем предсказание через ONNX
            float predictedPrice = PredictPrice(input);

            // Проверяем, что предсказание прошло успешно
            if (predictedPrice > 0)
            {
                txtResult.Text = $"Прогнозируемая цена: {predictedPrice:0,0} руб.";
            }
            else
            {
                txtResult.Text = "Ошибка при предсказании.";
            }
        }

        private float PredictPrice(float[] input)
        {
            try
            {
                // Используем ваш код для предсказания
                var predictor = new PricePredictor("lightgbm_exp.onnx");
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


        // Связываем слайдеры и текстовые поля
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
            string htmlFilePath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "osm_map.html");

            if (!File.Exists(htmlFilePath))
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
            <style> #map { width: 100%; height: 100vh; } </style>
        </head>
        <body>
            <div id='map'></div>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    var map = L.map('map').setView([55.751244, 37.618423], 12);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; OpenStreetMap contributors'
                    }).addTo(map);
                });
            </script>
        </body>
        </html>";

                File.WriteAllText(htmlFilePath, htmlContent);
            }

            OSMMapBrowser.Navigate(new Uri(htmlFilePath));
        }
       


    }
    public class PricePredictor
    {
        private readonly InferenceSession _session;
        private readonly float[] _meanValues = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }; // Средние значения

        public PricePredictor(string modelPath)
        {
            _session = new InferenceSession(modelPath);
        }

        public float Predict(float[] inputFeatures)
        {
            try
            {
                int requiredLength = 17;

                // Если признаков меньше 17, дополняем средними значениями
                float[] fullInput = inputFeatures.Concat(_meanValues.Skip(inputFeatures.Length).Take(requiredLength - inputFeatures.Length)).ToArray();

                // Создаём тензор
                var inputTensor = new DenseTensor<float>(fullInput, new int[] { 1, fullInput.Length });

                var inputs = new NamedOnnxValue[]
                {
                NamedOnnxValue.CreateFromTensor("input", inputTensor)
                };

                using (var results = _session.Run(inputs))
                {
                    var output = results.First().AsEnumerable<float>().ToArray();
                    return output[0]; // Возвращаем исходное значение без преобразования
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при предсказании: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            return -1;
        }
    }
}
