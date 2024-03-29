import 'package:dairy_app/core/utils/utils.dart';
import 'package:dairy_app/core/widgets/glass_dialog.dart';
import 'package:dairy_app/features/auth/core/constants.dart';
import 'package:dairy_app/features/auth/presentation/bloc/user_config/user_config_cubit.dart';
import 'package:dairy_app/features/sync/presentation/widgets/cloud_user_info.dart';
import 'package:dairy_app/features/sync/presentation/widgets/sync_now_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SyncSettings extends StatelessWidget {
  const SyncSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sync",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<UserConfigCubit, UserConfigState>(
            builder: (context, state) {
              final hasChoosenCloudSource =
                  state.userConfigModel?.preferredSyncOption != null;
              final isSignedIn =
                  (state.userConfigModel?.googleDriveUserInfo != null);
              return SwitchListTile(
                activeColor: Colors.pinkAccent,
                contentPadding: const EdgeInsets.all(0),
                title:
                    const Text("Auto sync", style: TextStyle(fontSize: 16.0)),
                subtitle: const Text("Automatically sync notes with cloud"),
                value: state.userConfigModel?.isAutoSyncEnabled == true,
                onChanged: (bool val) {
                  if (!isSignedIn) {
                    showToast("please login to enable auto-sync");
                    return;
                  }
                  final userConfigCubit =
                      BlocProvider.of<UserConfigCubit>(context);
                  userConfigCubit.setUserConfig(
                      UserConfigConstants.isAutoSyncEnabled, val);
                },
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("Sync now", style: TextStyle(fontSize: 16.0)),
              Spacer(),
              SyncNowButton(),
              SizedBox(width: 8.0),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Available platforms for sync",
              style: TextStyle(fontSize: 16.0)),
          const SizedBox(height: 10.0),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showCustomDialog(
                    context: context,
                    child: CloudUserInfo(
                      imagePath: "assets/images/google_drive_icon.png",
                      cloudSourceName: "google_drive",
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white.withOpacity(0.2),
                      // decoration: const BoxDecoration(color: Colors.pinkAccent),
                    ),
                    Image.asset(
                      "assets/images/google_drive_icon.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
