import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends ConsumerWidget {
  const DonatePage({super.key});

  static const String _rialDonationUrl =
      'https://donate.sudoshz.ir/u/shahriaarrr';

  static const List<_CryptoDonation> _cryptoDonations = [
    _CryptoDonation(
      currency: 'گرام',
      symbol: 'GRAM',
      network: 'TON',
      address: 'UQCBswvOSCFjUsSQbhxSkNuO1PgzMHtyDAt-Eap0pnSMU024',
      color: Color.fromARGB(255, 3, 165, 194),
      icon: Icons.diamond,
    ),
    _CryptoDonation(
      currency: 'ترون',
      symbol: 'TRX',
      network: 'TRON (TRC20)',
      address: 'TArbRNCjw3K1TTUP4Lp5chcQUsNw4L8tgf',
      color: Color.fromARGB(255, 226, 48, 8),
      icon: Icons.rocket_launch_outlined,
    ),
    _CryptoDonation(
      currency: 'بیت‌کوین',
      symbol: 'BTC',
      network: 'BNB Smart Chain (BEP20)',
      address: '0x26C18d9434bD7D246392fB1818B9818403d764d1',
      color: Color(0xFFF7931A),
      icon: Icons.currency_bitcoin_rounded,
    ),
    _CryptoDonation(
      currency: 'اتریوم',
      symbol: 'ETH',
      network: 'Ethereum (ERC20)',
      address: '0x26C18d9434bD7D246392fB1818B9818403d764d1',
      color: Color(0xFF627EEA),
      icon: Icons.diamond_outlined,
    ),
    _CryptoDonation(
      currency: 'تتر',
      symbol: 'USDT',
      network: 'TRON (TRC20)',
      address: 'TArbRNCjw3K1TTUP4Lp5chcQUsNw4L8tgf',
      color: Color.fromARGB(255, 20, 219, 120),
      icon: Icons.monetization_on_outlined,
    ),
    _CryptoDonation(
      currency: 'بایننس کوین',
      symbol: 'BNB',
      network: 'BNB Smart Chain (BEP20)',
      address: '0x26C18d9434bD7D246392fB1818B9818403d764d1',
      color: Color.fromARGB(255, 255, 193, 7),
      icon: Icons.currency_exchange_outlined,
    ),
  ];

  Future<void> _openRialDonation() async {
    final uri = Uri.parse(_rialDonationUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('آدرس با موفقیت کپی شد'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
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
              'حمایت مالی',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'SUPPORT US',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIntro(),
              const SizedBox(height: 20),
              _buildRialSection(),
              const SizedBox(height: 20),
              _buildCryptoSection(context),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade500],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(
                child: Text(
                  'همراه ادامه مسیر باشید',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'مشهد مترو یک پروژه رایگان و متن‌باز است. حمایت شما به نگهداری اطلاعات ایستگاه‌ها، بهبود نقشه و توسعه قابلیت‌های جدید کمک می‌کند تا این راهنما همیشه برای شهروندان و زائران در دسترس بماند.',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: 15, height: 1.9),
          ),
        ],
      ),
    );
  }

  Widget _buildRialSection() {
    return _buildSection(
      title: 'حمایت ریالی',
      icon: Icons.account_balance_wallet_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'برای حمایت با کارت بانکی از درگاه پرداخت استفاده کنید.',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _openRialDonation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'درگاه حمایتی یاور',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.credit_card_outlined, size: 19),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoSection(BuildContext context) {
    return _buildSection(
      title: 'حمایت با ارز دیجیتال',
      icon: Icons.currency_exchange_rounded,
      child: Column(
        children: [
          Text(
            'لطفاً پیش از ارسال، نوع ارز و شبکه را با دقت بررسی کنید.',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          ..._cryptoDonations.map(
            (donation) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCryptoCard(context, donation),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(BuildContext context, _CryptoDonation donation) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: donation.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: donation.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(donation.icon, color: donation.color, size: 25),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${donation.currency} (${donation.symbol})',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'شبکه: ${donation.network}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _copyAddress(context, donation.address),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.copy_rounded, color: donation.color, size: 19),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      donation.address,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'monospace',
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
            color: Colors.black.withValues(alpha: 0.2),
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
}

class _CryptoDonation {
  const _CryptoDonation({
    required this.currency,
    required this.symbol,
    required this.network,
    required this.address,
    required this.color,
    required this.icon,
  });

  final String currency;
  final String symbol;
  final String network;
  final String address;
  final Color color;
  final IconData icon;
}
