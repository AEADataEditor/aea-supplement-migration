# OpenICPSR File Walker

This script walks OpenICPSR project pages to collect file listings, including directory structure and file sizes.

## Setup

1. Create a virtual environment and install dependencies:

```bash
cd programs
python3 -m venv venv
./venv/bin/pip install -r requirements.txt
```

2. Configure Cloudflare token (required to bypass bot protection):

Create a `.env` file in the project root:
```bash
cp ../.env.example ../.env
# Edit .env and add your ICPSR_TOKEN
```

Or pass the token via command line:
```bash
./venv/bin/python walk_openicpsr_files.py --token YOUR_TOKEN_HERE
```

## Usage

### Process all DOIs from CSV:

```bash
./venv/bin/python walk_openicpsr_files.py
```

### Test with a single DOI:

```bash
./venv/bin/python walk_openicpsr_files.py --test-doi 10.3886/e231553v1
```

### Custom input/output files:

```bash
./venv/bin/python walk_openicpsr_files.py \
  --input ../data/acquired/icpsr_dois_2025_may.csv \
  --output ../data/acquired/icpsr_files_2025_may.csv
```

### Adjust request delay:

```bash
./venv/bin/python walk_openicpsr_files.py --delay 2.0
```

## Options

- `--token TOKEN`: Cloudflare token for OpenICPSR (overrides ICPSR_TOKEN in .env)
- `--input FILE`: Input CSV file with DOIs (default: ../data/acquired/icpsr_dois_2025_may.csv)
- `--output FILE`: Output CSV file for file listings (default: ../data/acquired/icpsr_files_2025_may.csv)
- `--delay SECONDS`: Delay between requests in seconds (default: 1.0)
- `--test-doi DOI`: Test with a single DOI instead of processing the full CSV

## Output Format

The output CSV file contains three columns:
- `doi`: The DOI of the project (e.g., "10.3886/e231553v1")
- `filename`: The file path relative to the project root (e.g., "data/myfile.csv")
- `filesize`: The file size as reported by OpenICPSR (e.g., "1.2 MB")

## Example

```bash
# Test with single DOI
./venv/bin/python walk_openicpsr_files.py --test-doi 10.3886/e231553v1

# Process all DOIs
./venv/bin/python walk_openicpsr_files.py
```
