// CLI-only library exports.
//
// The runtime Flutter widgets (AutoLingoApp, AutoText, TranslationService, etc.)
// live in the companion Flutter package — not in this CLI tool.
library autolingo;

export 'src/arb_generator.dart';
export 'src/cli_style.dart';
export 'src/extractor.dart';
export 'src/init_command.dart';
export 'src/lingo_runner.dart';
