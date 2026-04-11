import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Custom/custom_primary_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: AboutContainer()),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CustomPrimaryText(text: "Developer", size: 14),
                        CustomBoldText(text: "Spoidy", size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class AboutContainer extends StatefulWidget {
  const AboutContainer({super.key});

  @override
  State<AboutContainer> createState() => _AboutContainerState();
}

class _AboutContainerState extends State<AboutContainer> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/icon/app_icon.png'),
            ),
            const SizedBox(height: 8),
            const CustomBoldText(text: "Insanity", size: 20),
            const SizedBox(height: 4),
            CustomPrimaryText(
              text: _version.isEmpty
                  ? "Loading version..."
                  : "Version $_version",
              size: 13,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
