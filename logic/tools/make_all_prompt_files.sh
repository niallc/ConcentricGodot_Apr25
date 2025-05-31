cd ~/concentric2_apr2025/archive/PromptFiles/

python ../../logic/tools/print_project_tree.py > ./printed_project_tree.txt

python ../../logic/tools/make_big_code_file.py .gd
python ../../logic/tools/make_big_code_file.py .tres
python ../../logic/tools/make_big_code_file.py .tscn