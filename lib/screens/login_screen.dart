import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/sbi_tokens.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onPreview;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onPreview,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final appState = context.read<AppState>();
    final success = await appState.login(_emailCtrl.text.trim(), _passwordCtrl.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      widget.onLoginSuccess();
    } else {
      setState(() {
        _errorMessage =
            'We could not find a match for that email and password. '
            'Please check your credentials or purchase access through the Resource Library.';
      });
    }
  }

  void _openShop() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Visit spicybehavioralinstitute.com to purchase access'),
        backgroundColor: SBIColors.burgundy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SBISpacing.pageMargin,
            vertical: SBISpacing.sp8,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: SBISpacing.sp8),
                  // ── Seal ──────────────────────────────────────────────────
                  _SBISeal(),
                  const SizedBox(height: SBISpacing.sp5),
                  // ── Product Name ──────────────────────────────────────────
                  const Text(
                    'SBI Success Cards™',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: SBIColors.gold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp2),
                  Text(
                    'Log in to your SBI account to access\nyour purchased resource.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: SBIColors.ivory.withValues(alpha: 0.80),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp8),
                  // ── Login Card ────────────────────────────────────────────
                  _LoginCard(
                    formKey: _formKey,
                    emailCtrl: _emailCtrl,
                    passwordCtrl: _passwordCtrl,
                    obscurePassword: _obscurePassword,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    onLogin: _handleLogin,
                    onPurchase: _openShop,
                    onPreview: widget.onPreview,
                  ),
                  const SizedBox(height: SBISpacing.sp6),
                  // ── Trust Badges ──────────────────────────────────────────
                  const _TrustBadges(),
                  const SizedBox(height: SBISpacing.sp8),
                  // ── Footer ────────────────────────────────────────────────
                  Text(
                    '© Spicy Behavioral Institute™ · All rights reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: SBIColors.ivory.withValues(alpha: 0.40),
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SBI Seal Widget ──────────────────────────────────────────────────────────
class _SBISeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SBIColors.burgundy,
        border: Border.all(color: SBIColors.gold, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: SBIColors.gold.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SBI',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SBIColors.gold,
              letterSpacing: 2,
            ),
          ),
          Text(
            '★',
            style: TextStyle(fontSize: 10, color: SBIColors.gold),
          ),
        ],
      ),
    );
  }
}

// ─── Login Card ───────────────────────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onPurchase;
  final VoidCallback onPreview;

  const _LoginCard({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorMessage,
    required this.onToggleObscure,
    required this.onLogin,
    required this.onPurchase,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        boxShadow: [SBIShadows.sm],
      ),
      padding: const EdgeInsets.all(SBISpacing.sp6),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section Label ─────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: SBIColors.navy.withValues(alpha: 0.5)),
                const SizedBox(width: 6),
                Text(
                  'Member Login',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SBIColors.navy.withValues(alpha: 0.5),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SBISpacing.sp5),
            // ── Email Field ───────────────────────────────────────────────
            _SBITextField(
              controller: emailCtrl,
              label: 'Email Address',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Please enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: SBISpacing.sp4),
            // ── Password Field ────────────────────────────────────────────
            _SBITextField(
              controller: passwordCtrl,
              label: 'Password',
              hint: '••••••••',
              obscureText: obscurePassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              onSuffixTap: onToggleObscure,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your password';
                if (v.length < 4) return 'Password must be at least 4 characters';
                return null;
              },
            ),
            // ── Error Message ─────────────────────────────────────────────
            if (errorMessage != null) ...[
              const SizedBox(height: SBISpacing.sp3),
              Container(
                padding: const EdgeInsets.all(SBISpacing.sp3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(SBIRadius.sm),
                  border: Border.all(color: const Color(0xFFFFB74D), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Color(0xFFE65100)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5D4037),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: SBISpacing.sp5),
            // ── Log In Button ─────────────────────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SBIColors.gold,
                  foregroundColor: SBIColors.navy,
                  disabledBackgroundColor: SBIColors.gold.withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: SBIColors.navy,
                        ),
                      )
                    : const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: SBISpacing.sp3),
            // ── Divider ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: Divider(color: SBIColors.navy.withValues(alpha: 0.15))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(
                      fontSize: 12,
                      color: SBIColors.navy.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Expanded(child: Divider(color: SBIColors.navy.withValues(alpha: 0.15))),
              ],
            ),
            const SizedBox(height: SBISpacing.sp3),
            // ── Purchase Button ────────────────────────────────────────────
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: onPurchase,
                style: OutlinedButton.styleFrom(
                  foregroundColor: SBIColors.burgundy,
                  side: const BorderSide(color: SBIColors.burgundy, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                  ),
                ),
                child: const Text(
                  'Purchase in Resource Library',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: SBISpacing.sp3),
            // ── Preview Link ───────────────────────────────────────────────
            Center(
              child: TextButton(
                onPressed: onPreview,
                style: TextButton.styleFrom(
                  foregroundColor: SBIColors.navy.withValues(alpha: 0.6),
                ),
                child: const Text(
                  'Preview cards without an account →',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SBI Text Field ───────────────────────────────────────────────────────────
class _SBITextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;

  const _SBITextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: SBIColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: SBIColors.navy),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: SBIColors.navy.withValues(alpha: 0.35), fontSize: 14),
            prefixIcon: Icon(prefixIcon, size: 18, color: SBIColors.navy.withValues(alpha: 0.5)),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, size: 18, color: SBIColors.navy.withValues(alpha: 0.5)),
                  )
                : null,
            filled: true,
            fillColor: SBIColors.stone50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SBISpacing.sp4,
              vertical: SBISpacing.sp4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SBIRadius.sm),
              borderSide: BorderSide(color: SBIColors.navy.withValues(alpha: 0.20)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SBIRadius.sm),
              borderSide: BorderSide(color: SBIColors.navy.withValues(alpha: 0.20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SBIRadius.sm),
              borderSide: const BorderSide(color: SBIColors.gold, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SBIRadius.sm),
              borderSide: BorderSide(color: SBIColors.burgundy.withValues(alpha: 0.7)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SBIRadius.sm),
              borderSide: const BorderSide(color: SBIColors.burgundy, width: 2),
            ),
            errorStyle: const TextStyle(fontSize: 12, color: SBIColors.burgundy),
          ),
        ),
      ],
    );
  }
}

// ─── Trust Badges ─────────────────────────────────────────────────────────────
class _TrustBadges extends StatelessWidget {
  const _TrustBadges();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TrustBadge(icon: Icons.lock_outline, label: 'Secure'),
        _divider(),
        _TrustBadge(icon: Icons.person_outline, label: 'Member Access'),
        _divider(),
        _TrustBadge(icon: Icons.bolt_outlined, label: 'Instant Delivery'),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp3),
    child: Text(
      '·',
      style: TextStyle(color: SBIColors.ivory.withValues(alpha: 0.30), fontSize: 18),
    ),
  );
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: SBIColors.gold.withValues(alpha: 0.80)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: SBIColors.ivory.withValues(alpha: 0.65),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
