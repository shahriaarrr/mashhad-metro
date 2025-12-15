import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  static const String _repoURL = "https://github.com/shahriaarrr/mashhad-metro";

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text(
              'درباره ما',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ABOUT US',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade700,
                          Colors.deepPurple.shade500,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.subway,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'مشهد مترو',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final version = snapshot.data!.version;
                        final buildNumber = snapshot.data!.buildNumber;
                        final showBuildNumber =
                            buildNumber.isNotEmpty &&
                            int.tryParse(buildNumber) != null &&
                            int.parse(buildNumber) > 1;
                        return Text(
                          'نسخه $version${showBuildNumber ? ' ($buildNumber)' : ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        );
                      }
                      return Text(
                        'نسخه ...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSection(
              title: 'درباره اپلیکیشن',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'اپلیکیشن مترو مشهد یک راهنمای جامع و کاربردی برای استفاده از سیستم مترو شهر مشهد مقدس است. این اپلیکیشن با هدف تسهیل سفرهای روزانه شهروندان و گردشگران طراحی شده و اطلاعات کاملی از ایستگاه‌ها، خطوط مختلف، امکانات هر ایستگاه و مسیریابی را در اختیار شما قرار می‌دهد.\n\n'
                    'با استفاده از این برنامه می‌توانید:\n',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),

                  _buildBulletPoint(
                    'لیست کامل ایستگاه‌های تمام خطوط مترو را مشاهده کنید',
                  ),
                  _buildBulletPoint(
                    'اطلاعات دقیق هر ایستگاه شامل آدرس، امکانات و موقعیت مکانی را ببینید',
                  ),
                  _buildBulletPoint(
                    'موقعیت ایستگاه‌ها را روی نقشه مشاهده کنید',
                  ),
                  _buildBulletPoint(
                    'ایستگاه‌های دارای امکانات خاص مانند آسانسور، سرویس بهداشتی، وای‌فای و... را پیدا کنید',
                  ),
                  _buildBulletPoint(
                    'به راحتی بین خطوط مختلف جابجا شوید و ایستگاه‌های مشترک را شناسایی کنید',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'این اپلیکیشن به صورت کاملاً رایگان و متن‌باز (Open Source) در دسترس شماست و امیدواریم بتواند همراه مفیدی در سفرهای روزانه شما باشد.\n\n',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 22,
                      height: 1.8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(_repoURL),
                      icon: const Icon(Icons.code, size: 20),
                      label: const Text(
                        'مخزن پروژه در گیت هاب',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: 'ویژگی های برجسته',
              icon: Icons.star_outline,
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.map_outlined,
                    title: 'نقشه تعاملی',
                    description:
                        'مشاهده تمام ایستگاه ها روی نقشه با قابلیت زوم و جابجایی',
                  ),
                  _buildFeatureItem(
                    icon: Icons.info_outlined,
                    title: 'اطلاعات کامل',
                    description:
                        'دسترسی به جزئیات کامل هر ایستگاه شامل امکانات و آدرس',
                  ),
                  _buildFeatureItem(
                    icon: Icons.offline_bolt,
                    title: 'دسترسی آفلاین',
                    description:
                        'استفاده از اطلاعات ایستگاه ها بدون نیاز به اینترنت',
                  ),
                  _buildFeatureItem(
                    icon: Icons.accessibility_new,
                    title: 'دسترسی آسان',
                    description: 'طراحی ساده و مورد پسند برای همه گروه های سنی',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 8),

            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '© ۱۴۰۴ - اپلیکیشن مترو مشهد',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ساخته شده با ❤️ برای زائرین و مجاورین امام رضا(ع)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple.shade300, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Icon(Icons.circle, size: 6, color: Colors.white70),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
