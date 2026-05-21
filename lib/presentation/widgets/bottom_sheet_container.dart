import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BottomSheetContainer extends StatelessWidget {
  const BottomSheetContainer({
    required this.child,
    required this.onCloseTap,
    this.backgroundColor = Colors.white,
    this.cornerRadius = 20,
    this.verticalPadding = 10,
    this.horizontalPadding = 20,
    this.closeIcon,
    super.key,
  });

  final Function() onCloseTap;
  final Color backgroundColor;
  final double cornerRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final Widget child;
  final Widget? closeIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 0,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
            ),
          ),
          child: SizedBox(
            width: screenWidth(context),
            child: PaddingWidget.applySymmetricPadding(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BottomSheetCloseButton(
                    closeIcon: closeIcon,
                    onTap: onCloseTap,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<Function()>.has("onCloseTap", onCloseTap))
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(DoubleProperty("cornerRadius", cornerRadius))
      ..add(DoubleProperty("verticalPadding", verticalPadding))
      ..add(DoubleProperty("horizontalPadding", horizontalPadding));
  }
}

@AppPreview(name: "Bottom Sheet Container")
Widget bottomSheetContainerPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: BottomSheetContainer(
        onCloseTap: () {},
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text("Sample bottom sheet content"),
        ),
      ),
    ),
  );
}
