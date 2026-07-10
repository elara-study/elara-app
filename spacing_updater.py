
import os, re

dirs = [
    "lib/features/student/presentation/views",
    "lib/features/student/presentation/widgets",
    "lib/features/auth/presentation/views",
    "lib/features/auth/presentation/widgets",
    "lib/shared/widgets"
]

spacing_map = {
    "2": "AppSpacing.spacing2xs",
    "4": "AppSpacing.spacingXs",
    "8": "AppSpacing.spacingSm",
    "12": "AppSpacing.spacingMd",
    "16": "AppSpacing.spacingLg",
    "20": "AppSpacing.spacingXl",
    "24": "AppSpacing.spacing2xl",
    "32": "AppSpacing.spacing3xl",
    "36": "AppSpacing.spacing4xl",
    "40": "AppSpacing.spacing5xl",
    "48": "AppSpacing.spacing6xl",
    "56": "AppSpacing.spacing7xl",
    "64": "AppSpacing.spacing8xl",
}

for d in dirs:
    if not os.path.exists(d): continue
    for root, _, files in os.walk(d):
        for f in files:
            if not f.endswith(".dart"): continue
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8") as file:
                content = file.read()
            
            original = content
            
            def replace_match(match):
                num_str = match.group(1)
                extension = match.group(2)
                return f"{spacing_map[num_str]}.{extension}"

            content = re.sub(r"\b(2|4|8|12|16|20|24|32|36|40|48|56|64)(?:\.0)?\.(w|h)\b", replace_match, content)

            if content != original:
                if "import 'package:elara/core/theme/app_spacing.dart';" not in content:
                    lines = content.split("\n")
                    # Find last import
                    last_import = -1
                    for i, l in enumerate(lines):
                        if l.startswith("import "):
                            last_import = i
                    if last_import != -1:
                        lines.insert(last_import + 1, "import 'package:elara/core/theme/app_spacing.dart';")
                    else:
                        lines.insert(0, "import 'package:elara/core/theme/app_spacing.dart';")
                    content = "\n".join(lines)
                
                with open(path, "w", encoding="utf-8") as file:
                    file.write(content)
                print(f"Updated {path}")

