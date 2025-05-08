using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Diagnostics;
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
    /// Логика взаимодействия для MapPage.xaml
    /// </summary>
    public partial class MapPage : Page
    {
        public MapPage()
        {
            SetWebBrowserFeatureControl();
            InitializeComponent();
        }

        private void SetWebBrowserFeatureControl()
        {
            string appName = Process.GetCurrentProcess().ProcessName + ".exe";
            using (var key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION"))
            {
                key.SetValue(appName, 11001, RegistryValueKind.DWord);
            }
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
}
