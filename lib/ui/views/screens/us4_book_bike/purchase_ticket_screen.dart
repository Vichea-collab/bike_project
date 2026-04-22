import 'package:flutter/material.dart';

import 'booking_success_screen.dart';
import 'view_model/booking_view_model.dart';
import 'widgets/booking_flow_shared.dart';
import 'widgets/purchase_ticket_content.dart';

class PurchaseTicketScreen extends StatelessWidget {
  const PurchaseTicketScreen({super.key, required this.viewModel});

  final BookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Step 2 of 3')),
          body: BookingFlowBackground(
            child: PurchaseTicketContent(
              viewModel: viewModel,
              onPay: () => _payTicket(context),
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _payTicket(BuildContext context) async {
    final booked = await viewModel.paySingleTicketAndConfirmBooking();

    if (!context.mounted) {
      return;
    }

    if (!booked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.actionError ?? 'Unable to confirm the booking.',
          ),
        ),
      );
      return;
    }

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BookingSuccessScreen(viewModel: viewModel),
      ),
    );

    if (!context.mounted || result != true) {
      return;
    }

    Navigator.of(context).pop(true);
  }
}
