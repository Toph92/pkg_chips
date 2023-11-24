// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'common.dart';

class ChipTextControler extends ChangeNotifier {
  String? _textValue;
  String? get textValue => _textValue;

  set textValue(String? value) {
    _textValue = value;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class ChipText extends StatefulWidget {
  ChipText({
    super.key,
    required this.controler,
    this.bgColor = Colors.white,
    this.textFieldWidth = 180,
    this.emptyMessage = "Clic pour saisir",
    this.txtStyle = const TextStyle(fontWeight: FontWeight.w500),
    this.icon = Icons.help,
    this.deleteTooltipMessage = "Supprimer",
    this.tooltipMessage,
    this.tooltipMessageEmpty,
    this.iconColor,
    this.removable = false,
    this.bottomMessage,
  });

  ChipTextControler controler;
  final Color bgColor;
  final double textFieldWidth;
  final String emptyMessage;
  final TextStyle txtStyle;
  final IconData? icon;
  final String deleteTooltipMessage;
  final String? tooltipMessageEmpty;
  final String? tooltipMessage;
  final String? bottomMessage;
  final Color? iconColor;
  final bool removable;

  ValueNotifier<bool?>? _visibleNotif = ValueNotifier(true);

  @override
  State<ChipText> createState() => _ChipTextState();
}

class _ChipTextState extends State<ChipText> with ChipMixin {
  bool editMode = false;
  //String? value;
  FocusNode focus = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    focus.addListener(() {
      if (focus.hasFocus == false) {
        /* controller.text == ""
            ? widget.textValue = null
            : widget.textValue = controller.text; */
        controller.text == ""
            ? widget.controler._textValue = null
            : widget.controler._textValue = controller.text;
        editMode = false;
        setState(() {});
      }
    });

    widget._visibleNotif?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    widget.controler.addListener(() {
      if (!mounted) return;
      widget.controler.textValue == null
          ? controller.clear()
          : controller.text = widget.controler.textValue ?? "";
      ChipStringNotification(widget.controler.textValue).dispatch(context);
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    widget._visibleNotif?.dispose();
    widget._visibleNotif = null;

    widget.controler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controler.textValue != null &&
            widget.bottomMessage != null &&
            editMode == false
        ? displayBottomMessage = true
        : displayBottomMessage = false;
    return // widget._visibleNotif?.value == true
        Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
                alwaysIncludeSemantics: false,
                opacity: animation,
                child:
                    child); //ScaleTransition(scale: animation, child: child);
          },
          child: editMode
              ? Container(
                  width: widget.textFieldWidth,
                  decoration: BoxDecoration(
                      color: widget.bgColor,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 32, // empirique la hauteur :(
                      child: TextField(
                          onChanged: (value) {
                            ChipStringNotification(value).dispatch(context);
                          },
                          autofocus: true,
                          focusNode: focus,
                          controller: controller,
                          style: widget.txtStyle,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              widget.icon,
                              color: widget.iconColor ??
                                  Theme.of(context).primaryColor,
                              size:
                                  24, // ici aussi, à l'oeil pour la hauteur pour avoir la même taille qua dans le chip. Bon, en faisant une constante (partagée avec chip), ce sera mieux
                            ),
                            //labelText: widget.label,
                            /* hintText: widget.label,
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14), */
                            labelStyle: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500),
                            isDense: true,
                            //border: const OutlineInputBorder(),
                          )),
                    ),
                  ))
              : Tooltip(
                  message: controller.text != ""
                      ? widget.tooltipMessage ?? ""
                      : widget.tooltipMessageEmpty ?? "",
                  child: Theme(
                    data: ThemeData(useMaterial3: false),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          editMode = !editMode;
                        });
                      },
                      child: Chip(
                        /* materialTapTargetSize:
                                  MaterialTapTargetSize., */
                        elevation: 4.0,
                        visualDensity: const VisualDensity(vertical: 0),
                        backgroundColor: widget.bgColor,
                        labelPadding: const EdgeInsets.all(2.0),
                        color: MaterialStatePropertyAll(widget.bgColor),
                        avatar: Icon(
                          widget.icon,
                          color: widget.iconColor ??
                              Theme.of(context).primaryColor,
                        ),
                        deleteIconColor: Colors.grey.shade700,
                        deleteButtonTooltipMessage: widget.deleteTooltipMessage,
                        deleteIcon: null,
                        onDeleted: widget.removable ||
                                widget.controler.textValue != null
                            ? () {
                                if (widget.controler.textValue != null) {
                                  widget.controler.textValue = null;
                                  controller.clear();
                                  ChipStringNotification(null)
                                      .dispatch(context);
                                } else {
                                  ChipDeleteNotification().dispatch(context);
                                }
                              }
                            : null,
                        label: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: widget.controler.textValue == null
                              ? FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.emptyMessage,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                          width: widget.controler.textValue ==
                                                      null &&
                                                  widget.removable == false
                                              ? 10
                                              : 0),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(widget.controler.textValue ?? ""),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        wdBottomMessage(widget.bottomMessage)
      ],
    );
    //: const SizedBox();
  }
}
