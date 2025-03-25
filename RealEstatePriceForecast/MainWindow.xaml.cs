using Microsoft.Win32;
using System;
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
        }

        private void OnSearchClick(object sender, RoutedEventArgs e)
        {
            
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
}
