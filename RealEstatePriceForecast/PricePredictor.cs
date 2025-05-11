using Microsoft.ML.OnnxRuntime.Tensors;
using Microsoft.ML.OnnxRuntime;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace RealEstatePriceForecast
{
    public class PricePredictor
    {
        private readonly InferenceSession _session;

        // Минимальные значения для 9 числовых признаков (взяты из scaler.data_min_)
        private readonly float[] _mins = {
        0f,         // Minutes to metro
        0f,         // Number of rooms
        6f,         // Area
        2f,         // Living area
        1f,         // Kitchen area
        1f,         // Floor
        1f,         // Number of floors
        55.431841f, // Latitude
        37.138168f  // Longitude
    };

        // Диапазоны (scale = max - min), из scaler.data_max_ - scaler.data_min_
        private readonly float[] _scales = {
        60f,        // Minutes to metro
        12f,        // Number of rooms
        1111f,      // Area
        564.8f,     // Living area
        121f,       // Kitchen area
        91f,        // Floor
        96f,        // Number of floors
        0.548354f,  // Latitude
        0.790162f   // Longitude
    };

        public PricePredictor(string modelPath)
        {
            _session = new InferenceSession(modelPath);
        }

        public float Predict(float[] inputFeatures)
        {
            if (inputFeatures.Length != 17)
                throw new ArgumentException("Требуется 17 параметров");

            float[] scaledFeatures = (float[])inputFeatures.Clone();

            // Индексы числовых признаков
            int[] numericalIndices = { 0, 1, 2, 3, 4, 5, 6, 15, 16 };

            for (int i = 0; i < numericalIndices.Length; i++)
            {
                int idx = numericalIndices[i];
                scaledFeatures[idx] = (inputFeatures[idx] - _mins[i]) / _scales[i];
            }

            var inputTensor = new DenseTensor<float>(scaledFeatures, new[] { 1, 17 });
            var inputs = new List<NamedOnnxValue>
        {
            NamedOnnxValue.CreateFromTensor("input", inputTensor)
        };

            using (var results = _session.Run(inputs))
            {
                // Получаем предсказанное значение и применяем экспоненту
                float predictedLogPrice = results.First().AsEnumerable<float>().First();

                // Применяем экспоненту для восстановления реальной цены
                float predictedPrice = (float)Math.Exp(predictedLogPrice);

                return predictedPrice;
            }
        }
    }

}
