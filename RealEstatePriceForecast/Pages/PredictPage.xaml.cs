using System;
using System.Collections.Generic;
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

namespace RealEstatePriceForecast.Pages
{
    /// <summary>
    /// Логика взаимодействия для PredictPage.xaml
    /// </summary>
    public partial class PredictPage : Page
    {
        private float _latitude;
        private float _longitude;
        private PredictionsEntities _context = new PredictionsEntities();

        public PredictPage()
        {
            InitializeComponent();
            comboMetroStation.ItemsSource = _context.MetroStations.ToList();
        }

        private void cmbMetroStations_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (comboMetroStation.SelectedItem is MetroStations selectedStation)
            {
                _latitude = (float)selectedStation.Latitude;
                _longitude = (float)selectedStation.Longitude;
            }
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
                    !float.TryParse(txtTotalFloors.Text, out float totalFloors))
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

                if (_latitude == 0 || _longitude == 0)
                {
                    MessageBox.Show("Выберите станцию метро.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
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
                _latitude, _longitude
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
    }
}
