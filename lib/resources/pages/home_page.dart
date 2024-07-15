import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/report.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:flutter_app/resources/widgets/box_color.dart';
import 'package:flutter_app/utils/datetime_utils.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  init() {
    super.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Effect(
        (e) {
          final state = controller.homeSignal.value;
          print(state);
          if (state is LogOutState) {
            routeTo(
              LoginPage.path,
              navigationType: NavigationType.pushAndForgetAll,
            );
          } else if (state is SubmitDailyState) {
            controller.getTacos();
          }
        },
      );
    });
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTacosSession(signal.username, signal.tacos),
                        SizedBox(height: 32),
                        _buildWeeklyReportWidget(signal.weeklyReport),
                        SizedBox(height: 32),
                        _buildDailyReportWidget(
                          signal.dailyReports,
                          signal.selectedReport,
                        ),
                      ],
                    ),
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
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
              Divider(thickness: 1),
              BoxColor(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
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
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Text(
                          'Report',
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

  Widget _buildDailyReportWidget(
    List<Report> dailyReports,
    Report? selected,
  ) {
    if (selected == null) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Daily',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: dailyReports
              .map(
                (report) => _buildDailyReportCircle(
                  report,
                  report.createdAt.isSameDay(selected.createdAt!),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 12),
        _buildDailyReportCard(selected),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDailyReportCircle(Report report, bool isSelected) {
    final isToday = report.createdAt.isSameDay(DateTime.now());
    final isBefore = report.createdAt?.isBefore(DateTime.now());

    final isReported = report.content != null;
    return Expanded(
      child: BoxColor(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: isReported
              ? Colors.green
              : isBefore == true
                  ? Colors.red
                  : Colors.transparent,
        ),
        color: isSelected
            ? isReported
                ? Colors.green
                : Colors.red
            : isReported || isBefore == true
                ? Colors.white
                : Color(0xFFdddddd),
        padding: EdgeInsets.all(6),
        child: Center(
          child: Text(
            '${report.createdAt?.day ?? '--'}',
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReportCard(Report report) {
    final isReported = report.content != null;
    return BoxColor(
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black12,
        )
      ],
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BoxColor(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
            color: isReported ? Colors.green : Colors.orange.shade300,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isReported ? 'Reported' : 'Waiting',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isReported)
                  Text(
                    report.createdAt?.toFormat(DateFormat.HOUR24_MINUTE) ??
                        '--',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ],
            ),
          ),
          BoxColor(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            color: Colors.white,
            child: report.content != null
                ? SizedBox(
                    height: 200,
                    child: Text(
                      report.content ?? '--',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                : BoxColor(
                    onTap: () {
                      controller.openDailyReportBottomSheet(context);
                    },
                    margin: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'public/assets/svg/no_data.svg',
                          height: 120,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No data',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16),
                        BoxColor(
                          borderRadius: BorderRadius.circular(16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Theme.of(context).colorScheme.primary,
                          child: Text(
                            'Report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTacosSession(String? user, int tacos) {
    if (user == null) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tacos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                user,
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
              Text(
                '${tacos} 🌮',
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
