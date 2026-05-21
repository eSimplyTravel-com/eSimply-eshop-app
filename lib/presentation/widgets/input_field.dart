import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/note_text.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.placeholder,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.formatter,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.isReadOnly = false,
    this.smallVersion = false,
    super.key,
  });
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String? validationMessage;
  final void Function()? enterPressed;
  final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String? additionalNote;
  final Function(String)? onChanged;
  final TextInputFormatter? formatter;

  @override
  InputFieldState createState() => InputFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>("controller", controller),
      )
      ..add(DiagnosticsProperty<TextInputType>("textInputType", textInputType))
      ..add(DiagnosticsProperty<bool>("password", password))
      ..add(DiagnosticsProperty<bool>("isReadOnly", isReadOnly))
      ..add(StringProperty("placeholder", placeholder))
      ..add(StringProperty("validationMessage", validationMessage))
      ..add(
        ObjectFlagProperty<void Function()?>.has(
          "enterPressed",
          enterPressed,
        ),
      )
      ..add(DiagnosticsProperty<bool>("smallVersion", smallVersion))
      ..add(DiagnosticsProperty<FocusNode?>("fieldFocusNode", fieldFocusNode))
      ..add(DiagnosticsProperty<FocusNode?>("nextFocusNode", nextFocusNode))
      ..add(EnumProperty<TextInputAction>("textInputAction", textInputAction))
      ..add(StringProperty("additionalNote", additionalNote))
      ..add(
        ObjectFlagProperty<Function(String p1)?>.has("onChanged", onChanged),
      )
      ..add(DiagnosticsProperty<TextInputFormatter?>("formatter", formatter));
  }
}

class InputFieldState extends State<InputField> {
  bool isPassword = false;
  double fieldHeight = 55;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.smallVersion ? 40 : fieldHeight,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration:
              widget.isReadOnly ? disabledFieldDecoration : fieldDecoration,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.formatter != null
                      ? <TextInputFormatter>[widget.formatter!]
                      : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed?.call();
                    }
                  },
                  onFieldSubmitted: (String value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode?.requestFocus();
                    }
                  },
                  obscureText: isPassword,
                  readOnly: widget.isReadOnly,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.placeholder,
                    hintStyle:
                        TextStyle(fontSize: widget.smallVersion ? 12 : 15),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isPassword = !isPassword;
                }),
                child: widget.password
                    ? Container(
                        width: fieldHeight,
                        height: fieldHeight,
                        alignment: Alignment.center,
                        child: () {
                          final IconData visibilityIcon = isPassword
                              ? Icons.visibility
                              : Icons.visibility_off;
                          return Icon(visibilityIcon);
                        }(),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage!,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote!),
        verticalSpaceSmall,
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("isPassword", isPassword))
      ..add(DoubleProperty("fieldHeight", fieldHeight));
  }
}

@AppPreview(name: "Input Field")
Widget inputFieldPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: InputField(
        controller: TextEditingController(),
        placeholder: "Enter your name",
      ),
    ),
  );
}
