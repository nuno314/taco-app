import 'package:flutter/material.dart';

Widget buildModalBottomSheet({
  required BuildContext context,
  required Widget body,
  bool useRootNavigator = true,
  double? bottomPadding,
  String? title,
  void Function()? onClose,
}) {
  final mediaData = MediaQuery.of(context);

  final padding = mediaData.padding;
  final size = mediaData.size;
  final maxContentSize = size.height - padding.top - padding.bottom - 64;
  final _scrollController = ScrollController();
  final themeColor = Theme.of(context).colorScheme;
  return Padding(
    padding: mediaData.viewInsets,
    child: Wrap(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            bottom: bottomPadding ?? mediaData.padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(8),
              topStart: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('ModalBottomSheet_close_btn'),
                    onPressed: onClose ??
                        () => Navigator.of(
                              context,
                              rootNavigator: useRootNavigator,
                            ).pop(),
                    icon: Icon(
                      Icons.close,
                      size: 24,
                      color: themeColor.primary,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 1,
                thickness: 0.2,
                color: themeColor.primary,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: maxContentSize),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: body,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Future<dynamic> showModal(
  BuildContext context,
  Widget body, {
  bool useRootNavigator = true,
  double? bottomPadding,
  String? title,
  void Function()? onClose,
}) {
  return showModalBottomSheet<dynamic>(
    context: context,
    useRootNavigator: useRootNavigator,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return buildModalBottomSheet(
        context: context,
        body: body,
        bottomPadding: bottomPadding,
        onClose: onClose,
        title: title,
        useRootNavigator: useRootNavigator,
      );
    },
  );
}
