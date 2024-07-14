import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/report.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/widgets/box_color.dart';
import 'package:flutter_app/utils/datetime_utils.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/home_controller.dart';
import '/resources/widgets/safearea_widget.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static const path = '/home';

  HomePage({super.key}) : super(path, child: () => _HomePageState());
}

class _HomePageState extends NyState<HomePage> {
  /// [HomeController] controller
  HomeController get controller => widget.controller;
  late final Effect _effect;

  @override
  init() {
    super.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _effect = Effect(
        (e) {
          print('=go');
          final signal = controller.homeSignal.value;
          if (signal is SubmitWeeklyState) {
            controller.closeModal();
          }
        },
      );
    });
  }

  /// The boot method is called before the [view] is rendered.
  /// You can override this method to perform any async operations.
  /// Try uncommenting the code below.
  // @override
  // boot() async {
  //   dump("boot");
  //   await Future.delayed(Duration(seconds: 2));
  // }

  /// If you would like to use the Skeletonizer loader,
  /// uncomment the code below.
  // bool get useSkeletonizer => true;

  /// The Loading widget is shown while the [boot] method is running.
  /// You can override this method to show a custom loading widget.
  // @override
  // Widget loading(BuildContext context) {
  //   return Scaffold(
  //       body: Center(child: Text("Loading..."))
  //   );
  // }

  /// The [view] method should display your page.
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      key: controller.modelKey,
      appBar: AppBar(
        title: Text("Report App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => widget.controller.doLogOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SignalBuilder(
        signal: controller.homeSignal,
        builder: (context, signal, child) => signal.isLoading
            ? loader
            : SafeAreaWidget(
                child: BoxColor(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWeeklyReportWidget(signal.weeklyReport),
                      // _buildDailyReportWidget(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');

  Widget _buildWeeklyReportWidget(Report? report) {
    final _firstDateOfWeek = firstDateOfWeek(DateTime.now());
    final _lastDateOfWeek = lastDateOfWeek(DateTime.now());

    final isReported = report != null;
    final color =
        !isReported ? Theme.of(context).colorScheme.primary : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Weekly',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        BoxColor(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BoxColor(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 4),
                    Text(
                      '${_firstDateOfWeek.toFormat(DateFormat.MONTH_DAY)} - ${_lastDateOfWeek.toFormat(
                        DateFormat.MONTH_DAY,
                      )}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    if (!isReported)
                      Text(
                        '${_lastDateOfWeek.timeLeft(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {
                          controller.openWeeklyReportBottomSheet(
                            context,
                            isEditing: true,
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
              Divider(),
              BoxColor(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                padding: EdgeInsets.fromLTRB(16, 6, 16, 12),
                color: Colors.white,
                child: report != null
                    ? Text(report.content ?? '--')
                    : BoxColor(
                        onTap: () {
                          controller.openWeeklyReportBottomSheet(context);
                        },
                        color: color,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: Text(
                          'Please submit report',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _effect.dispose();
    super.dispose();
  }
}
