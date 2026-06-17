import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/utils/file_helper.dart";
import "package:flutter/cupertino.dart";

class OrderReceiptBottomSheetViewModel extends BaseModel {
  // OrderReceiptBottomSheetViewModel({required this.bundleOrderModel});

  late OrderHistoryResponseModel? bundleOrderModel;

  final GlobalKey globalKey = GlobalKey();

  Future<void> savePdf() async {
    await capturePdfAndShare(
      globalKey: globalKey,
      pdfFileName: bundleOrderModel?.bundleDetails?.bundleName ?? "",
    );
  }
}
