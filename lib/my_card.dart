import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as flutter_stripe;
import 'package:localisation_sample/constants.dart';

Widget myCard(BuildContext context,
    String image, String name, String date, String honey, String manufacturer,
    String value, String button, int amount) {

  Future<Map<String, dynamic>> _createTestPaymentSheet({required int amount}) async {
    final url = Uri.parse('$paymentIntentUrl/payment-sheet');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': amount.toString(),
      }),
    );
    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }
    return body;
  }

  Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server

      final jsonResponse = await _createTestPaymentSheet(amount: amount);
      log(jsonResponse.toString());

      final billingDetails = flutter_stripe.BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: flutter_stripe.Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      );

      //2. initialize the payment sheet
      await flutter_stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: flutter_stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
          testEnv: true,
          merchantCountryCode: 'US',
          billingDetails: billingDetails,
        ),
      );

      await flutter_stripe.Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed!')),
      );
    } catch (e) {
      if (e is flutter_stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.network(image),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
              Text(date),
              Text("$honey $manufacturer - $value"),
              ElevatedButton(
                child: Text("$button $value"),
                //кнопка оплаты неактивна, если мёда нет
                onPressed: _isHoneyUnAvailable(honey) ? null : () async {
                  await initPaymentSheet(context, email: "example@gmail.com", amount: amount);
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}

//проверка, есть ли мёд (ненулевое число банок)
bool _isHoneyUnAvailable(String honey) {
  var num = int.tryParse(honey[0]);
  if (num != null) {
    if (num == 0) { return true; }
    else { return false; }
  }
  return true;
}