import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key, required this.onSelected});
  final Function(String val) onSelected;

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String selectedMethod = '';
  List<String> paymentMethods = ['Mobile money', 'Bank transfer'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment methods',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: selectedMethod == paymentMethods[0]
                      ? Colors.black
                      : Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Radio(
                  value: selectedMethod,
                  groupValue: paymentMethods[0],
                  activeColor: kPrimaryColor,
                  onChanged: (val) => setState(() {
                        selectedMethod = paymentMethods[0];
                        widget.onSelected(selectedMethod);
                      })),
              const SizedBox(
                width: 6,
              ),
              const Text('Mobile money'),
              const Spacer(),
              Image.asset('assets/images/mpesa.png', height: 24),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: selectedMethod == paymentMethods[1]
                      ? Colors.black
                      : Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Radio(
                  value: selectedMethod,
                  groupValue: paymentMethods[1],
                  activeColor: kPrimaryColor,
                  onChanged: (val) => setState(() {
                        selectedMethod = paymentMethods[1];
                        widget.onSelected(selectedMethod);
                      })),
              const SizedBox(
                width: 6,
              ),
              const Text('Bank transfer'),
              const Spacer(),
              Image.asset('assets/images/mastercard.png', height: 24),
              const SizedBox(
                width: 4,
              ),
              Image.asset('assets/images/visa.png', height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
