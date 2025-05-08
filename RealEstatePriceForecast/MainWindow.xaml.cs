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
using RealEstatePriceForecast.Pages;

namespace RealEstatePriceForecast
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {       
        public MainWindow()
        {
            InitializeComponent();
        }

        private void btnPredict_Click_1(object sender, RoutedEventArgs e)
        {
            MainFrame.Navigate(new PredictPage());
        }

        private void btnCalculate_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.Navigate(new CalculatePage());
        }

        private void btnMap_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.Navigate(new MapPage());
        }
    }
}
