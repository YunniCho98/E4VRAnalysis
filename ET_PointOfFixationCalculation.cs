using EyeMap_Application.Models;
using System.Linq;

namespace EyeMap_Application.Engines;

internal static class PointOfFixationCalculation
{
        private const int DEFAULT_MAX_ANGLE = 5;
        private const long MIN_TIMESTAMP_DIFF = 5_000_000; // 10_000_000 = 1 second

        public static IEnumerable<PointOfFixation> CalculatePointOfFixations(List<EyeGazeData> AllEyeGazeData, double maxAngle = DEFAULT_MAX_ANGLE)
        {
                if (AllEyeGazeData.Count == 0)
                        return Enumerable.Empty<PointOfFixation>();

                var results = new List<PointOfFixation>();

                var streak = 0;
                long startTimestamp = 0;
                var origins = new List<(double, double)>();

                for (var index = 0; index < AllEyeGazeData.Count - 1; index += 1)
                {
                        // If Time between this and next data is too time streatched
                        if (AllEyeGazeData[index + 1].Timestamp - AllEyeGazeData[index].Timestamp > ThreshHoldValues.Frequency)
                        {
                                // If datas before where a "Point of Fixation" add it to the results
                                if (streak != 0)
                                {
                                        var timestampDifference = AllEyeGazeData[index].Timestamp - startTimestamp;
                                        if (timestampDifference > MIN_TIMESTAMP_DIFF)
                                        {
                                                var (originX, originY) = Moy.Calculate(origins);
                                                results.Add(new PointOfFixation(originX, originY, streak, timestampDifference));
                                        }
                                }
                                // Reset and continue for next data
                                startTimestamp = 0;
                                origins.Clear();
                                streak = 0;
                                continue;
                        }

                        // Calculate the dispertion between this and next data
                        var dispertionAngle = CalculateDispertion(AllEyeGazeData[index].Vector, AllEyeGazeData[index + 1].Vector);
                        // Acceptable dispertion, continue the streak
                        if (dispertionAngle < maxAngle)
                        {
                                if (startTimestamp == 0)
                                        startTimestamp = AllEyeGazeData[index].Timestamp;
                                origins.Add((AllEyeGazeData[index].EstimationX, AllEyeGazeData[index].EstimationY));
                                streak += 1;
                        }
                        // If not, but there was a streak, add pof to the results and reset streak
                        else if (streak != 0)
                        {
                                var timestampDifference = AllEyeGazeData[index].Timestamp - startTimestamp;
                                if (timestampDifference > MIN_TIMESTAMP_DIFF)
                                {
                                        var (originX, originY) = Moy.Calculate(origins);
                                        results.Add(new PointOfFixation(originX, originY, streak, timestampDifference));
                                }

                                startTimestamp = 0;
                                origins.Clear();
                                streak = 0;
                        }
                }

                return results;
        }


        private static double CalculateDispertion(Vector3D a, Vector3D b)
        {
                return Math.Acos(
                                (a.X * b.X + a.Y * b.Y + a.Z * b.Z) /
                                (a.Norm() * b.Norm())
                        ) * 180 / Math.PI;
        }
}
