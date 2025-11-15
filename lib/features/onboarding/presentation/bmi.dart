import 'package:flutter/material.dart';



class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String weightUnit = 'kg'; // kg or lbs
  String heightUnit = 'cm'; // cm or inch

  double? bmi;
  String bmiCategory = '';

  void calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;

    if (weight <= 0 || height <= 0) return;

    double weightKg = weightUnit == 'lbs' ? weight * 0.453592 : weight;
    double heightM = heightUnit == 'cm' ? height / 100 : height * 2.54 / 100;

    double result = weightKg / (heightM * heightM);

    String category = '';
    if (result < 18.5) {
      category = 'Underweight';
    } else if (result < 25) {
      category = 'Normal weight';
    } else if (result < 30) {
      category = 'Overweight';
    } else {
      category = 'Obesity';
    }

    setState(() {
      bmi = result;
      bmiCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Weight
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: weightUnit,
                  items: const [
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      weightUnit = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Height
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Height',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: heightUnit,
                  items: const [
                    DropdownMenuItem(value: 'cm', child: Text('cm')),
                    DropdownMenuItem(value: 'inch', child: Text('inch')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      heightUnit = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateBMI,
              child: const Text('Calculate BMI'),
            ),

            const SizedBox(height: 30),

            if (bmi != null)
              Text(
                'Your BMI: ${bmi!.toStringAsFixed(2)}\nCategory: $bmiCategory',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
