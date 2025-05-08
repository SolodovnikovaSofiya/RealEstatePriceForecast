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
                    return (float)Math.Exp(output[0]) / 10;
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
