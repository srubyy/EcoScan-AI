import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';


class WasteService {
  // PASTE YOUR GEMINI API KEY INSIDE THE QUOTES BELOW
  static const String apiKey = 'AIzaSyCWwrVKh_QkggYp4wxeAnz1-eqj4Z7nEdU';

  Future<String> identifyWaste(File imageFile) async {
    try {
      // 1. Setup the Gemini Model
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      // 2. The "Magic Prompt" - Instructions for the AI
      final prompt = TextPart(
          "You are an expert waste management assistant. "
          "Identify the item in the image. "
          "1. Name the item. "
          "2. Material (Plastic, Glass, Paper, etc.). "
          "3. Suggest disposal (Recycle, Compost, Landfill). "
          "Keep it short (max 50 words)."
      );

      // 3. Prepare the image
      final imageBytes = await imageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      // 4. Send to Gemini and wait for answer
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      return response.text ?? "Could not identify waste.";
    } catch (e) {
      return "Error: $e";
    }
  }
}