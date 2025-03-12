import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';

class EmptyBalanceCard extends StatelessWidget {
  const EmptyBalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorName.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorName.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Create a wallet to see your balance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Nunito',
          ),
        ),
      ),
    );
  }
}
