call venv\Scripts\activate

python -m robot -d output -P libraries -P resources -P variables --logtitle "Task log" tasks/

call venv\Scripts\deactivate
