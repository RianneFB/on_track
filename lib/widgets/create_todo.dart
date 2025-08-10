import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_track/controllers/data_controller.dart';
import 'package:on_track/models/todo.dart';
import 'package:uuid/uuid.dart';

class CreateTodo extends StatefulWidget {
  final DateTime? selectedDay;
  final bool isEdit;
  final Todo? todo;
  const CreateTodo({
    super.key,
    this.selectedDay,
    this.isEdit = false,
    this.todo,
  });

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final DataController _dataController = Get.put(DataController());
  final _formKey = GlobalKey<FormState>();
  late String title;
  late bool remindMe;
  var uuid = Uuid();

  @override
  void initState() {
    remindMe = widget.isEdit ? widget.todo!.isReminder : false;
    title = widget.isEdit ? widget.todo!.title : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(200),
        surfaceTintColor: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: TextFormField(
                    initialValue: title,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.lora(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Create a task...',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                    autocorrect: false,
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value != null && value.length <= 4) {
                        return "Task title is too short.";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SwitchListTile(
                value: remindMe,
                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                onChanged: (bool newValue) {
                  setState(() {
                    remindMe = newValue;
                  });
                },
                title: const Text('Remind me'),
              ),
              Gap(50.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(16.w),
                  FilledButton(
                    onPressed: _handleSave,
                    child: const Text('Done'),
                  ),
                  Gap(30.w),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              Gap(70.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (widget.isEdit) {
        final todo =
            widget.todo!
              ..title = title
              ..isReminder = remindMe;
        _dataController.updateTaskItemToServer(todo);

        if (remindMe) {
          _dataController.notificationService.showTaskNotification(todo);
        }
      } else {
        final todo = Todo(
          todoDate: widget.selectedDay!.toUtc(),
          createdAt: DateTime.now().toUtc(),
          title: title,
          isReminder: remindMe,
          isDone: false,
          id: uuid.v1(),
        );
        _dataController.putTaskItemsToServer(todo);

        if (remindMe) {
          _dataController.notificationService.showTaskNotification(todo);
        }
      }
      Navigator.pop(context);
    }
  }
}
