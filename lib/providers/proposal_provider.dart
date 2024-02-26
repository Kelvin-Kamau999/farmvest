import 'dart:io';

import 'package:cofarmer/common/api_service.dart';
import 'package:cofarmer/models/investment_model.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ProposalProvider with ChangeNotifier {
  List<ProposalModel> _proposals = [];
  List<ProposalModel> get proposals => _proposals;

  InvestmentModel? _lastInvestment;
  InvestmentModel? get lastInvestment => _lastInvestment;

  Future<void> getProposals() async {
    final proposals = await kProposalsRef.get();
    _proposals = proposals.docs.map((e) => ProposalModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> createProposal(ProposalModel proposal) async {
    final id = kProposalsRef.doc().id;
    proposal.id = id;

    List imageUrls = [];

    for (File imageFile in proposal.imageFiles!) {
      final url = await FirebaseStorage.instance
          .ref('proposals/$id')
          .putFile(imageFile)
          .then((value) => value.ref.getDownloadURL());
      imageUrls.add(url);
    }
    proposal.images = imageUrls;

    await kProposalsRef.doc(id).set(proposal.toJson());
    notifyListeners();
  }

  Future<void> investInProposal(InvestmentModel investment) async {
    final id = kInvestmentsRef.doc().id;
    investment.id = id;
    await kInvestmentsRef.doc(id).set(investment.toJson());
    _lastInvestment = investment;

    notifyListeners();
  }
}
