// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_app/app/models/profile.dart';
import 'package:flutter_app/app/models/report.dart';
import 'package:flutter_app/resources/widgets/bottom_sheet.dart';
import 'package:flutter_app/resources/widgets/button_widget.dart';
import 'package:flutter_app/resources/widgets/input_container.dart';
import 'package:flutter_app/utils/datetime_utils.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '/resources/widgets/logo_widget.dart';
import 'controller.dart';

class HomeController extends Controller {
  late final AuthSolidController authController;

  final _weeklyReportCtrl = TextEditingController();
  final _weeklyReportFcn = FocusNode();

  final _dailyReportCtrl = TextEditingController();
  final _dailyReportFcn = FocusNode();

  late PersistentBottomSheetController _modalController;
  GlobalKey<ScaffoldState> modelKey = GlobalKey();

  @override
  construct(BuildContext context) {
    super.construct(context);
    authController = Solid.get<AuthSolidController>(context);
    userId = supabase.auth.currentSession!.user.id;
    homeSignal = Signal<HomeState>(const HomeStateInitial());

    getProfile();
    getWeeklyReport();
  }

  final supabase = Supabase.instance.client;
  late final userId;

  onTapDocumentation() async {
    await launchUrl(Uri.parse("https://nylo.dev/docs"));
  }

  onTapGithub() async {
    await launchUrl(Uri.parse("https://github.com/nylo-core/nylo"));
  }

  onTapChangeLog() async {
    await launchUrl(Uri.parse("https://github.com/nylo-core/nylo/releases"));
  }

  onTapYouTube() async {
    await launchUrl(Uri.parse("https://m.youtube.com/@nylo_dev"));
  }

  showAbout() {
    showAboutDialog(
      context: context!,
      applicationName: getEnv('APP_NAME'),
      applicationIcon: const Logo(),
      applicationVersion: nyloVersion,
    );
  }

  doLogOut(BuildContext context) {
    authController.logOut();
  }

  Future<void> getProfile() async {
    try {
      supabase.from("profiles").select().eq('id', userId).single().then((json) {
        final user = Profile.fromJson(json);
        print(user.username);
      });
    } catch (e) {}
  }

  late final Signal<HomeState> homeSignal;

  Future<void> getWeeklyReport() async {
    showLoading();
    try {
      supabase
          .from("weekly-reports")
          .select()
          .eq('user_id', userId)
          .gte(
            'created_at',
            firstDateOfWeek(DateTime.now()).toIso8601String(),
          )
          .lte(
            'created_at',
            lastDateOfWeek(DateTime.now()).toIso8601String(),
          )
          .maybeSingle()
          .then((json) {
        if (json != null) {
          final report = Report.fromJson(json);
          homeSignal.set(
            homeSignal.value.copyWith(
              viewModel:
                  homeSignal.value.viewModel.copyWith(weeklyReport: report),
            ),
          );
        }
        hideLoading();
      });
    } catch (e) {
      hideLoading();
    }
  }

  Future<void> postWeeklyReport(Report report) async {
    try {} catch (e) {}
  }

  void openWeeklyReportBottomSheet(
    BuildContext context, {
    bool isEditing = false,
  }) {
    if (isEditing)
      _weeklyReportCtrl.text = homeSignal.value.weeklyReport!.content!;
    showModal(
      context,
      title: 'Weekly Report',
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            TextFieldWidget(
              controller: _weeklyReportCtrl,
              focusNode: _weeklyReportFcn,
              maxLines: 5,
            ),
            SizedBox(height: 26),
            SignalBuilder(
              signal: homeSignal,
              builder: (context, signal, child) => ValueListenableBuilder(
                valueListenable: _weeklyReportCtrl,
                builder: (context, value, child) => ButtonWidget.primary(
                  enable: value.text.isNotEmpty && !signal.isLoading,
                  context: context,
                  title: 'Submit',
                  onPressed:
                      isEditing ? updateWeeklyReport : insertWeeklyReport,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  HomeState get homeState => homeSignal.value;

  insertWeeklyReport() {
    showLoading();

    try {
      final report = Report(
        userId: userId,
        content: _weeklyReportCtrl.text,
        createdAt: DateTime.now(),
      );
      supabase
          .from("weekly-reports")
          .insert(report.toJson())
          .select()
          .then((json) {
        final _report = Report.fromJson(json);
        homeSignal.set(
          homeState.copyWith<SubmitWeeklyState>(
            viewModel: homeState.viewModel.copyWith(
              weeklyReport: _report,
            ),
          ),
        );
        hideLoading();
      });
    } catch (e) {
      print(e.toString());
      hideLoading();
    }
  }

  updateWeeklyReport() {
    showLoading();

    try {
      final report = Report(
        userId: userId,
        content: _weeklyReportCtrl.text,
        createdAt: DateTime.now(),
      );
      supabase
          .from("weekly-reports")
          .update(report.toJson())
          .select()
          .then((json) {
        final _report = Report.fromJson(json.first);
        homeSignal.set(
          homeState.copyWith<SubmitWeeklyState>(
            viewModel: homeState.viewModel.copyWith(
              weeklyReport: _report,
            ),
          ),
        );
        hideLoading();
      });
    } catch (e) {
      print(e.toString());
      hideLoading();
    }
  }

  showLoading() {
    homeSignal.set(
      homeSignal.value.copyWith(
        viewModel: homeSignal.value.viewModel.copyWith(isLoading: true),
      ),
    );
  }

  hideLoading() {
    homeSignal.set(
      homeSignal.value.copyWith(
        viewModel: homeSignal.value.viewModel.copyWith(isLoading: false),
      ),
    );
  }

  closeModal() {}
}

class _ViewModel {
  final bool isLoading;
  final Report? weeklyReport;
  final Report? dailyReport;
  const _ViewModel({
    this.isLoading = false,
    this.weeklyReport,
    this.dailyReport,
  });

  _ViewModel copyWith({
    bool? isLoading,
    Report? weeklyReport,
    Report? dailyReport,
  }) {
    return _ViewModel(
      isLoading: isLoading ?? this.isLoading,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      dailyReport: dailyReport ?? this.dailyReport,
    );
  }
}

abstract class HomeState {
  final _ViewModel viewModel;

  const HomeState(this.viewModel);

  T copyWith<T extends HomeState>({
    _ViewModel? viewModel,
  }) {
    return _factories[T == HomeState ? runtimeType : T]!(
      viewModel ?? this.viewModel,
    );
  }

  Report? get weeklyReport => viewModel.weeklyReport;
  bool get isLoading => viewModel.isLoading;
}

class HomeStateInitial extends HomeState {
  const HomeStateInitial({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

class SubmitWeeklyState extends HomeState {
  SubmitWeeklyState({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

final _factories = <Type,
    Function(
  _ViewModel viewModel,
)>{
  HomeStateInitial: (viewModel) => HomeStateInitial(
        viewModel: viewModel,
      ),
  SubmitWeeklyState: (viewModel) => SubmitWeeklyState(
        viewModel: viewModel,
      ),
};
