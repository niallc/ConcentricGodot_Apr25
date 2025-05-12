import os
import re

def find_pattern_in_files(string, projectDir = "/Users/niallHome/concentric2_apr2025/"):
   # rawString = string.encode('unicode_escape').decode()
   rawString = string
   pattern = re.compile(rawString, re.IGNORECASE)

   for root, _, files in os.walk(projectDir):
       for file in files:
           if file.endswith(".gd"):
               path = os.path.join(root, file)
               with open(path, "r", encoding="utf-8", errors="ignore") as f:
                   for i, line in enumerate(f, start=1):
                       if pattern.search(line):
                           print(f"{path}:{i}:{line.strip()}")
