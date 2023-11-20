import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'common.dart';

class ChipDate extends StatefulWidget {
  ChipDate(
      {super.key,
      this.bgColor = Colors.white,
      this.textFieldWidth = 180,
      this.emptyMessage = "Clic pour saisir",
      this.txtStyle = const TextStyle(fontWeight: FontWeight.w500),
      this.icon,
      this.deleteTooltipMessage = "Supprimer",
      visible = true,
      this.tooltipMessage,
      this.tooltipMessageEmpty,
      this.iconColor,
      this.removable = false,
      this.bottomMessage}) {
    this.visible = visible;
  }

  final Color bgColor;
  final double textFieldWidth;
  //final String label;
  final String emptyMessage;
  final TextStyle txtStyle;
  final IconData? icon;
  final String deleteTooltipMessage;
  final String? tooltipMessageEmpty;
  final String? tooltipMessage;
  final String? bottomMessage;
  final Color? iconColor;
  final bool removable;

  bool _visible = true;
  get visible => _visible;

  set visible(value) {
    _visible = value;
    _visibleNotif?.value = value;
  }

  DateTime? _dateValue;
  DateTime? get dateValue => _dateValue;

  set dateValue(value) {
    _dateValue = value;
    _valueNotif?.value = value;
  }

  ValueNotifier<bool?>? _visibleNotif = ValueNotifier(true);
  ValueNotifier<DateTime?>? _valueNotif = ValueNotifier(null);
  @override
  State<ChipDate> createState() => _ChipDateState();
}

class _ChipDateState extends State<ChipDate> with ChipMixin {
  @override
  void initState() {
    widget._visibleNotif?.addListener(() {
      if (mounted) {
        setState(() {}); // i refresh is date is changed
      }
    });
    widget._valueNotif?.addListener(() {
      if (mounted) {
        setState(() {}); // i refresh is date is changed
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._visibleNotif?.dispose();
    widget._visibleNotif = null;

    widget._valueNotif?.dispose();
    widget._valueNotif = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.dateValue != null && widget.bottomMessage != null
        ? displayBottomMessage = true
        : displayBottomMessage = false;

    return widget._visibleNotif?.value == true
        ? Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  await _selectDate(context, widget.dateValue).then((value) {
                    setState(() {
                      if (value != null) {
                        widget.dateValue = value;
                        DateNotification(value).dispatch(context);
                        //setState(() {});
                        //widget.onUpdate?.call(widget.date.value);
                      }
                    });
                  });
                },
                child: Theme(
                  data: ThemeData(useMaterial3: false),
                  child: Chip(
                    elevation: 4.0,
                    visualDensity: const VisualDensity(vertical: 0),
                    backgroundColor: widget.bgColor,
                    labelPadding: const EdgeInsets.all(2.0),
                    color: MaterialStatePropertyAll(widget.bgColor),
                    deleteIconColor: Colors.grey.shade700,
                    onDeleted: widget.removable || widget.dateValue != null
                        ? () {
                            if (widget.dateValue != null) {
                              widget.dateValue = null;
                              DateNotification(null).dispatch(context);
                            } else {
                              ChipDeleteNotification().dispatch(context);
                            }
                          }
                        : null,

                    //onPressed: () => _selectDate(context),

                    avatar: Icon(
                      widget.icon ?? Icons.date_range,
                      color: widget.iconColor ?? Theme.of(context).primaryColor,
                    ),
                    label: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: FittedBox(
                        child: widget.dateValue == null
                            ? Text(
                                widget.emptyMessage,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                              )
                            : Text(
                                DateFormat('d/M/y').format(widget.dateValue!)),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
              wdBottomMessage(widget.bottomMessage)
            ],
          )
        : const SizedBox();
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      date = picked;
      return date;
    }
    return null;
  }
}
