import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/strings.dart';
import 'package:portfolio/widgets/glass_card.dart';

class ContactSection extends StatefulWidget {
  final ValueChanged<double> onVisible;
  final VoidCallback? onDownloadResume;

  const ContactSection({
    super.key,
    required this.onVisible,
    this.onDownloadResume,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _animate = false;
  final _formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launchUrl(uri)) {
      // url launched
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final platform = _emailController.text.trim();
      final subject = _subjectController.text.trim().isNotEmpty
          ? _subjectController.text.trim()
          : "Upwork Project Inquiry";
      final message = _messageController.text.trim();

      final inquiryText = "Project: $subject\nClient/Team: $name\nTarget Platform: $platform\nDetails:\n$message";
      await Clipboard.setData(ClipboardData(text: inquiryText));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Project brief copied to clipboard! Paste directly into Upwork Messages.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.greenAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(20),
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isCompact = size.width < 900;

    return VisibilityDetector(
      key: const Key('contact_section'),
      onVisibilityChanged: (info) {
        widget.onVisible(info.visibleFraction);
        if (info.visibleFraction > 0.12 && !_animate) {
          setState(() {
            _animate = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
        width: double.infinity,
        color: AppColors.surface,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                _buildSectionHeader(textTheme),
                const SizedBox(height: 60),

                // Contact Layout
                if (isCompact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildContactInfo(textTheme),
                      const SizedBox(height: 48),
                      _buildContactForm(textTheme),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _buildContactInfo(textTheme),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 6,
                        child: _buildContactForm(textTheme),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GET IN TOUCH",
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.primaryAccent,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Contact Me",
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ).animate(target: _animate ? 1 : 0).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildContactInfo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's connect",
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm currently available for full-time and hourly contracts on Upwork. Let's discuss your project scope, milestones, and deliver high-performance applications!",
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // Quick contacts
        _buildInfoTile(Icons.verified, "Platform", "Upwork Verified Freelancer", null),
        const SizedBox(height: 16),
        _buildInfoTile(Icons.schedule_outlined, "Availability", "Full-Time & Hourly Contracts", null),
        const SizedBox(height: 16),
        _buildInfoTile(Icons.bolt_outlined, "Response Time", "Quick Response (Within 2-4 Hours)", null),
        const SizedBox(height: 16),
        _buildInfoTile(Icons.location_on_outlined, "Location", AppStrings.devLocation, null),
        const SizedBox(height: 32),

        // CTA Row
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSocialIcon(Icons.code, AppStrings.githubUrl, "GitHub"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.greenAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.greenAccent.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shield_outlined, size: 16, color: AppColors.greenAccent),
                  SizedBox(width: 6),
                  Text(
                    "Upwork Safe & Verified",
                    style: TextStyle(
                      color: AppColors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).animate(target: _animate ? 1 : 0).fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, String? url) {
    final isLink = url != null;
    return InkWell(
      onTap: isLink ? () => _launchUrl(url) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryAccent, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isLink ? AppColors.secondaryAccent : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: IconButton(
          icon: Icon(icon, color: AppColors.textSecondary, size: 20),
          onPressed: () => _launchUrl(url),
          hoverColor: AppColors.primaryAccent.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildContactForm(TextTheme textTheme) {
    return GlassCard(
      glowColor: AppColors.primaryAccent,
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Start a Project on Upwork",
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Upwork TOS Safe",
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "To comply with Upwork Terms of Service, all initial client inquiries and contract engagements are conducted securely through Upwork Messages. Prepare your brief below to copy directly into Upwork:",
              style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 24),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Your Name / Organization",
                hintText: "Enter your name or company",
                prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textMuted),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter your name or company";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Platform Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Target Platform",
                hintText: "e.g. Flutter (Android & iOS) / Web",
                prefixIcon: Icon(Icons.devices_outlined, size: 20, color: AppColors.textMuted),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please specify target platform";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: "Project Title",
                hintText: "What is your project about?",
                prefixIcon: Icon(Icons.subject_outlined, size: 20, color: AppColors.textMuted),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a project title";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Project Scope & Details",
                hintText: "Describe features, timeline, and key goals...",
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.textMuted),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter project details";
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Action Button
            ElevatedButton(
              onPressed: _submitForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.copy_rounded, size: 16),
                  SizedBox(width: 10),
                  Text("Copy Project Brief for Upwork"),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(target: _animate ? 1 : 0).fadeIn(delay: 300.ms, duration: 600.ms);
  }
}
