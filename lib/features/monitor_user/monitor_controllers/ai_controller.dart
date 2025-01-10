import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiController extends GetxController {
  var isloading = false.obs;

  Future<void> imageDescriptionResponse(String imageToChat) async {
    isloading.value = true;

    try {
      var body = json.encode({
        'model': 'gpt-4o-mini',
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "Please analyze the road damage in this image and classify the severity as low, medium, or high. Provide a short explanation and indicate severity using color codes (e.g., green for low, yellow for medium, red for high).",
              },
              {
                "type": "image_url",
                "image_url": {"url": imageToChat}
              }
            ]
          },
        ]
      });

      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization':"Bearer ${dotenv.env['OPENAI_API_KEY']}"

        },
        body: body,
      );
      print(response.body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var severityDescription = data['choices'][0]['message']['content'];

        // Clean up the description by removing markdown (*** and ##)
        var cleanedDescription = _cleanDescription(severityDescription);

        // Show the dialog with the cleaned message
        _showDamageDialog(cleanedDescription);
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isloading.value = false;
    }
  }

  // Show the dialog with damage analysis
  void _showDamageDialog(String severityDescription) {
    String severityLevel = _getSeverityLevel(severityDescription);

    Color severityColor = _getSeverityColor(severityLevel);
    String formattedMessage =
        _formatMessage(severityDescription, severityLevel);

    Get.dialog(
      AlertDialog(
        title: Text(
          'Road Damage Analysis',
          style: TextStyle(color: severityColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formattedMessage),
            SizedBox(height: 10),
            Text(
              'Severity: $severityLevel',
              style:
                  TextStyle(color: severityColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Clean up the description by removing unwanted markdown like *** and ##
  String _cleanDescription(String description) {
    // Replace any markdown symbols with nothing (you can adjust this based on the actual response)
    description = description.replaceAll(RegExp(r'[#*]+'), '');
    return description.trim();
  }

  // Extract severity level from description (for simplicity, adjust this logic as needed)
  String _getSeverityLevel(String description) {
    if (description.contains('overwhelming') ||
        description.contains('significant')) {
      return 'High';
    } else if (description.contains('risk') ||
        description.contains('deteriorating')) {
      return 'Medium';
    }
    return 'Low';
  }

  // Assign color based on severity level
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  // Format the message with severity details
  String _formatMessage(String description, String severity) {
    return '$description\n\nThis damage is classified as $severity severity. Please take appropriate action.';
  }
}
