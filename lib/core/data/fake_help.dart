/// Fake Help Data
/// PHASE 1.5 BONUS: Help Screen
/// Mock data for FAQs and support

class FAQItem {
  final String question;
  final String answer;
  final String category;

  const FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class SupportContact {
  final String type;
  final String value;
  final String icon;

  const SupportContact({
    required this.type,
    required this.value,
    required this.icon,
  });
}

/// Help & Support Data
class FakeHelp {
  static const List<FAQItem> faqs = [
    // Account & Security
    FAQItem(
      question: 'What is a Duress PIN?',
      answer:
          'A Duress PIN is a special 4-digit code that activates emergency protection mode. When you use this PIN instead of your regular PIN, Shield enters a restricted mode that limits transaction amounts and conceals your true balance, protecting you in threatening situations.',
      category: 'Security',
    ),
    FAQItem(
      question: 'How do I change my PIN?',
      answer:
          'Go to Profile → Change PIN. You\'ll need to enter your current PIN, then create a new 4-digit PIN. For security, avoid using obvious patterns like 1234 or repeating digits.',
      category: 'Security',
    ),
    FAQItem(
      question: 'What is Ghost Mode?',
      answer:
          'Ghost Mode is a privacy feature that hides your true balance and transaction history. When active, you\'ll see a reduced "ghost balance" designed to protect your financial privacy in duress situations.',
      category: 'Security',
    ),

    // Payments & Transfers
    FAQItem(
      question: 'How do I send money?',
      answer:
          'Tap the "Pay" tab at the bottom, enter the amount, select a recipient from your contacts or enter their details, then slide to confirm. You\'ll receive instant confirmation once the payment is processed.',
      category: 'Payments',
    ),
    FAQItem(
      question: 'What are transaction limits?',
      answer:
          'Standard accounts have a daily limit of R25,000. In duress mode, transactions are automatically limited to R200 to protect your funds. Contact support to adjust limits based on your needs.',
      category: 'Payments',
    ),
    FAQItem(
      question: 'Can I schedule payments?',
      answer:
          'Scheduled payments will be available in Phase 2. For now, all payments are processed immediately upon confirmation.',
      category: 'Payments',
    ),

    // Wallets & Savings
    FAQItem(
      question: 'How do wallets work?',
      answer:
          'Shield lets you organize your money across multiple wallets: Main Wallet for everyday spending, Lunch Money for specific purposes, and Savings Pots for your goals. You can move money between wallets anytime.',
      category: 'Wallets',
    ),
    FAQItem(
      question: 'How do I create a savings goal?',
      answer:
          'Tap the + button in the Wallets screen to create a new savings pot. Set your target amount, deadline, and choose an icon. Shield will track your progress and show you how much you need to save per day/week.',
      category: 'Wallets',
    ),

    // Family Features
    FAQItem(
      question: 'How does Family Live Map work?',
      answer:
          'Parents can see real-time locations of family members who have granted permission. The map shows safe zones (like home and school), movement status, and battery levels. Children can enable/disable location sharing in the Safety Center.',
      category: 'Family',
    ),
    FAQItem(
      question: 'What permissions can parents control?',
      answer:
          'Parents can control: making payments, viewing full balance, online purchases, ATM withdrawals, spending limits, and location sharing. These permissions can be adjusted anytime from the child\'s control panel.',
      category: 'Family',
    ),

    // Troubleshooting
    FAQItem(
      question: 'My payment failed. What should I do?',
      answer:
          'Check your internet connection, ensure you have sufficient balance, and verify the recipient\'s details. If issues persist, contact support with the transaction reference number.',
      category: 'Troubleshooting',
    ),
    FAQItem(
      question: 'I forgot my PIN. How do I reset it?',
      answer:
          'PIN reset functionality will be available in Phase 2. For now, please contact support for assistance with PIN recovery.',
      category: 'Troubleshooting',
    ),
  ];

  static const List<SupportContact> supportContacts = [
    SupportContact(
      type: 'Phone Support',
      value: '0800 SHIELD (744 353)',
      icon: '📞',
    ),
    SupportContact(
      type: 'Email Support',
      value: 'support@shield.co.za',
      icon: '📧',
    ),
    SupportContact(
      type: 'WhatsApp',
      value: '+27 82 SHIELD',
      icon: '💬',
    ),
    SupportContact(
      type: 'Emergency Line',
      value: '0800 111 222 (24/7)',
      icon: '🚨',
    ),
  ];

  // Get FAQs by category
  static List<FAQItem> getFAQsByCategory(String category) {
    return faqs.where((faq) => faq.category == category).toList();
  }

  // Get all unique categories
  static List<String> get categories {
    return faqs.map((faq) => faq.category).toSet().toList();
  }

  // Search FAQs
  static List<FAQItem> searchFAQs(String query) {
    final lowerQuery = query.toLowerCase();
    return faqs
        .where((faq) =>
            faq.question.toLowerCase().contains(lowerQuery) ||
            faq.answer.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
