import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/shared/models/patient_profile_model.dart';
import '../../features/shared/models/appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _chatModel;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_key_here') {
      throw Exception('Gemini API key is missing. Please set it in the .env file.');
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: apiKey,
    );

    _chatModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: apiKey,
      systemInstruction: Content.system('''
You are a helpful, empathetic medical assistant. You do NOT diagnose diseases. 
You guide patients to understand their symptoms, suggest relevant medical 
specialties, and encourage them to book a consultation with a licensed doctor. 
Always recommend professional medical advice.
'''),
    );
  }

  /// Generates personalized health recommendations based on patient profile and history.
  Future<List<String>> getHealthRecommendations({
    required PatientProfileModel profile,
    required List<AppointmentModel> history,
  }) async {
    try {
      final historySummary = history.map((a) => '${a.specialty} visit on ${a.dateTime.toString().split(' ')[0]}').join(', ');
      
      final prompt = '''
Based on the following anonymized patient profile and appointment history, generate 3 to 5 personalized health tips or follow-up suggestions.
Format your response as a simple bulleted list with no introductory text.

${profile.getAnonymizedSummary()}

Appointment History:
\$historySummary
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      
      if (text == null) return [];

      // Parse the bulleted list
      return text
          .split('\n')
          .where((line) => line.trim().isNotEmpty && line.trim().startsWith(RegExp(r'^[-*]|\d+\.')))
          .map((line) => line.replaceFirst(RegExp(r'^[-*]\s*|\d+\.\s*'), '').trim())
          .toList();
    } catch (e) {
      print('Error getting health recommendations: \$e');
      throw Exception('Failed to generate recommendations. Please try again later.');
    }
  }

  /// Suggests the most relevant doctor specialties based on symptoms and profile.
  Future<List<String>> suggestDoctorSpecialties({
    required String symptoms,
    required PatientProfileModel profile,
  }) async {
    try {
      final prompt = '''
A patient is describing the following symptoms: "\$symptoms".
Their anonymized profile is:
${profile.getAnonymizedSummary()}

Based on this, what are the top 3 medical specialties they should consult?
Return ONLY a comma-separated list of the specialty names, nothing else. (e.g. Cardiologist, Dermatologist, General Practitioner)
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      
      if (text == null) return [];

      return text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error suggesting specialties: \$e');
      throw Exception('Failed to analyze symptoms. Please try again later.');
    }
  }

  /// Chat with the AI assistant
  Future<String> chatWithAssistant(List<Content> conversationHistory, String newMessage) async {
    try {
      final chat = _chatModel.startChat(history: conversationHistory);
      final response = await chat.sendMessage(Content.text(newMessage));
      
      return response.text ?? "I'm sorry, I couldn't process that request.";
    } catch (e) {
      print('Error in chat: \$e');
      throw Exception('Failed to send message. Please check your connection and API key.');
    }
  }
}
