import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/temperature_provider.dart';
import '../providers/auth_provider.dart';
import '../models/temp_unit.dart';
import '../widgets/thermometer_visual.dart';
import '../widgets/unit_selector.dart';
import '../widgets/result_card.dart';
import '../widgets/quick_reference.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _inputController;
  late final AnimationController _swapController;
  late final Animation<double> _swapAnimation;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController();

    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _swapAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(
        parent: _swapController,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  Future<void> _handleSwap() async {
    await _swapController.forward();

    if (!mounted) return;

    context.read<TemperatureProvider>().swapUnits();

    final provider = context.read<TemperatureProvider>();

    if (provider.inputValue != null) {
      _inputController.text = provider.format(provider.inputValue!);
    }

    _swapController.reset();
  }

  void _handleReferenceTap(double celsius) {
    final provider = context.read<TemperatureProvider>();
    provider.setFromReference(celsius);
    _inputController.text = provider.format(provider.inputValue!);
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah kamu yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showUserProfile() {
    final user = context.read<AuthProvider>().user;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Profil Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFF6B35),
                radius: 28,
                child: Text(
                  _getInitials(user?.email ?? 'U'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.email ?? '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Bergabung: ${user?.metadata.creationTime?.toString().split('.')[0] ?? '-'}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String email) {
    if (email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundColor: const Color(0xFFFF6B35),
                  child: Text(
                    _getInitials(authProvider.user?.email ?? 'U'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onSelected: (value) {
                  if (value == 'profile') {
                    _showUserProfile();
                  } else if (value == 'logout') {
                    _showLogoutDialog();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            authProvider.user?.email ?? 'Profil',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 12),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D0D1A),
              Color(0xFF1A0D2E),
              Color(0xFF0D1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeader(),
                      const SizedBox(height: 32),
                      const ThermometerVisual(),
                      const SizedBox(height: 32),
                      _buildConverterCard(),
                      const SizedBox(height: 24),
                      const ResultCard(),
                      const SizedBox(height: 24),
                      QuickReference(onTap: _handleReferenceTap),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.thermostat,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'ThermoConvert',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Konversi suhu dengan mudah & cepat',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildConverterCard() {
    final provider = context.watch<TemperatureProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          UnitSelector(
            label: 'DARI',
            selected: provider.fromUnit,
            onChanged: (unit) {
              context.read<TemperatureProvider>().setFromUnit(unit);
            },
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: provider.fromUnit.color.withOpacity(0.4),
              ),
            ),
            child: TextField(
              controller: _inputController,
              onChanged: (value) {
                context.read<TemperatureProvider>().onInputChanged(value);
              },
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              style: TextStyle(
                color: provider.fromUnit.color,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                suffixText: provider.fromUnit.symbol,
                suffixStyle: TextStyle(
                  color: provider.fromUnit.color.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _handleSwap,
            child: AnimatedBuilder(
              animation: _swapAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _swapAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          UnitSelector(
            label: 'KE',
            selected: provider.toUnit,
            onChanged: (unit) {
              context.read<TemperatureProvider>().setToUnit(unit);
            },
          ),
        ],
      ),
    );
  }
}