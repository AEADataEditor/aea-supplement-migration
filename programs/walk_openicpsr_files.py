"""
Walk OpenICPSR project pages to collect file listings.

This script reads DOIs from a CSV file, navigates to the corresponding
OpenICPSR project pages, and recursively collects all files with their
sizes, respecting directory structure.

Output: CSV with columns: doi, filename, filesize
"""

import argparse
import csv
import os
import re
import time
from pathlib import Path
from typing import List, Tuple, Optional
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup
from dotenv import load_dotenv


class OpenICPSRWalker:
    """Walker for OpenICPSR project pages."""

    def __init__(self, delay: float = 1.0, icpsr_token: Optional[str] = None):
        """
        Initialize the walker.

        Args:
            delay: Delay between requests in seconds to be respectful
            icpsr_token: Optional Cloudflare token for OpenICPSR
        """
        self.delay = delay
        self.icpsr_token = icpsr_token
        self.session = requests.Session()

        headers = {
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        }

        # Add ICPSR_TOKEN to headers if available
        if icpsr_token:
            headers["x-openicpsr-cloudflare-token"] = icpsr_token

        self.session.headers.update(headers)

    def doi_to_url(self, doi: str) -> str:
        """
        Convert a DOI to the corresponding OpenICPSR URL.

        Args:
            doi: DOI string (e.g., "10.3886/e231553v1")

        Returns:
            Full URL to the OpenICPSR project page
        """
        # Extract project number and version from DOI
        # Format: 10.3886/e{project_id}v{version}
        match = re.match(r'10\.3886/e(\d+)v(\d+)', doi)
        if not match:
            raise ValueError(f"Invalid DOI format: {doi}")

        project_id = match.group(1)
        version = match.group(2)

        return f"https://www.openicpsr.org/openicpsr/project/{project_id}/version/V{version}/view"

    def get_page(self, url: str) -> BeautifulSoup:
        """
        Fetch and parse a page.

        Args:
            url: URL to fetch

        Returns:
            BeautifulSoup object
        """
        time.sleep(self.delay)
        response = self.session.get(url)
        response.raise_for_status()
        return BeautifulSoup(response.content, 'html.parser')

    def parse_file_size(self, size_text: str) -> str:
        """
        Parse file size text and return as string.

        Args:
            size_text: Size text from the page (e.g., "1.2 MB")

        Returns:
            Size as string
        """
        # Clean up the size text
        return size_text.strip() if size_text else ""

    def walk_directory(self, url: str, base_path: str = "") -> List[Tuple[str, str]]:
        """
        Recursively walk a directory on OpenICPSR.

        Args:
            url: URL of the directory to walk
            base_path: Base path for building relative paths

        Returns:
            List of tuples (filepath, filesize)
        """
        files = []

        try:
            soup = self.get_page(url)

            # OpenICPSR uses a table with class "table table-striped"
            # Each row contains: Name, File Type, Size, Last Modified
            table = soup.find('table', class_='table-striped')

            if not table:
                print(f"  Warning: No file table found at {url}")
                return files

            # Parse table rows (skip header)
            rows = table.find_all('tr')

            for row in rows[1:]:  # Skip header row
                cells = row.find_all('td')

                if len(cells) < 3:
                    continue

                # Column 0: Name (with link)
                # Column 1: File Type
                # Column 2: Size
                # Column 3: Last Modified (optional)

                name_cell = cells[0]
                file_type_cell = cells[1]
                size_cell = cells[2]

                # Find the link
                link = name_cell.find('a', href=True)
                if not link:
                    continue

                href = link.get('href', '')
                name = link.get_text(strip=True)

                # Parse query parameters to determine if it's a file or folder
                # Format: ?path=/openicpsr/.../name&type=file or type=folder
                if 'type=folder' in href:
                    # This is a folder - recurse into it
                    folder_name = name
                    folder_url = urljoin(url, href)
                    new_base_path = f"{base_path}/{folder_name}" if base_path else folder_name

                    print(f"  Entering folder: {new_base_path}")
                    files.extend(self.walk_directory(folder_url, new_base_path))

                elif 'type=file' in href:
                    # This is a file
                    filename = name
                    filepath = f"{base_path}/{filename}" if base_path else filename

                    # Get file size from the size column
                    size = self.parse_file_size(size_cell.get_text())

                    files.append((filepath, size))
                    print(f"    Found file: {filepath} ({size})")

        except Exception as e:
            print(f"  Error walking {url}: {e}")
            import traceback
            traceback.print_exc()

        return files

    def walk_project(self, doi: str) -> List[Tuple[str, str]]:
        """
        Walk all files in an OpenICPSR project.

        Args:
            doi: DOI of the project

        Returns:
            List of tuples (filepath, filesize)
        """
        try:
            url = self.doi_to_url(doi)
            print(f"Walking {doi}:")
            print(f"  URL: {url}")

            files = self.walk_directory(url)

            print(f"  Total files found: {len(files)}")
            return files

        except Exception as e:
            print(f"Error processing {doi}: {e}")
            return []


def main():
    """Main function to walk all projects and generate output CSV."""

    # Parse command-line arguments
    parser = argparse.ArgumentParser(
        description='Walk OpenICPSR project pages to collect file listings.'
    )
    parser.add_argument(
        '--token',
        help='Cloudflare token for OpenICPSR (can also be set via ICPSR_TOKEN in .env)'
    )
    parser.add_argument(
        '--input',
        help='Input CSV file with DOIs (default: data/acquired/icpsr_dois_2025_may.csv)'
    )
    parser.add_argument(
        '--output',
        help='Output CSV file for file listings (default: data/acquired/icpsr_files_2025_may.csv)'
    )
    parser.add_argument(
        '--delay',
        type=float,
        default=1.0,
        help='Delay between requests in seconds (default: 1.0)'
    )
    parser.add_argument(
        '--test-doi',
        help='Test with a single DOI instead of processing the full CSV'
    )

    args = parser.parse_args()

    # Load .env file if it exists
    base_dir = Path(__file__).parent.parent
    env_path = base_dir / ".env"
    if env_path.exists():
        load_dotenv(env_path)
        print(f"Loaded environment from {env_path}")

    # Get ICPSR token from command line or environment
    icpsr_token = args.token or os.getenv('ICPSR_TOKEN')
    if icpsr_token:
        print("Using Cloudflare token for authentication")
    else:
        print("WARNING: No Cloudflare token provided. Requests may be blocked.")
        print("Set ICPSR_TOKEN in .env or use --token option")

    # Determine input/output paths
    if args.input:
        input_csv = Path(args.input)
    else:
        input_csv = base_dir / "data" / "acquired" / "icpsr_dois_2025_may.csv"

    if args.output:
        output_csv = Path(args.output)
    else:
        output_csv = base_dir / "data" / "acquired" / "icpsr_files_2025_may.csv"

    # Read DOIs from input CSV (or use single test DOI)
    if args.test_doi:
        dois = [args.test_doi]
    else:
        dois = []
        with open(input_csv, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                dois.append(row['doi'])

    # Check if output file exists and determine write mode
    output_exists = output_csv.exists()
    write_mode = 'w'
    write_header = True

    if output_exists:
        print(f"WARNING: Output file already exists: {output_csv}")
        print()
        try:
            response = input("Append to existing file or overwrite? (a/o): ").strip().lower()
            if response == 'a' or response == 'append':
                write_mode = 'a'
                write_header = False
                print("Will append to existing file (no header will be written)")
            elif response == 'o' or response == 'overwrite':
                write_mode = 'w'
                write_header = True
                print("Will overwrite existing file")
            else:
                print("Invalid response. Aborted.")
                return
        except (KeyboardInterrupt, EOFError):
            print("\nAborted by user.")
            return
        print()

    # Print configuration summary
    print("=" * 60)
    print("CONFIGURATION SUMMARY")
    print("=" * 60)
    print(f"Input file:          {input_csv}")
    print(f"Output file:         {output_csv}")
    print(f"Output mode:         {'Append' if write_mode == 'a' else 'Overwrite'}")
    print(f"Number of DOIs:      {len(dois)}")
    print(f"Request delay:       {args.delay} seconds")
    print(f"Token configured:    {'Yes' if icpsr_token else 'No'}")
    if args.test_doi:
        print(f"Test mode:           Yes (DOI: {args.test_doi})")
    else:
        print(f"Test mode:           No")
    print("=" * 60)
    print()

    # Wait for confirmation
    try:
        response = input("Proceed with this configuration? (Y/n): ").strip().lower()
        if response and response not in ['y', 'yes']:
            print("Aborted by user.")
            return
    except (KeyboardInterrupt, EOFError):
        print("\nAborted by user.")
        return

    print()
    print("Starting file collection...")
    print()

    # Initialize walker
    walker = OpenICPSRWalker(delay=args.delay, icpsr_token=icpsr_token)

    # Collect all files
    all_files = []

    for i, doi in enumerate(dois, 1):
        print(f"[{i}/{len(dois)}] Processing {doi}")

        try:
            files = walker.walk_project(doi)

            # Add DOI to each file record
            for filepath, filesize in files:
                all_files.append({
                    'doi': doi,
                    'filename': filepath,
                    'filesize': filesize
                })

        except Exception as e:
            print(f"  Failed to process {doi}: {e}")

        print()

    # Write output CSV
    if write_mode == 'a':
        print(f"Appending {len(all_files)} file records to {output_csv}")
    else:
        print(f"Writing {len(all_files)} file records to {output_csv}")

    with open(output_csv, write_mode, encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['doi', 'filename', 'filesize'])
        if write_header:
            writer.writeheader()
        writer.writerows(all_files)

    print("Done!")


if __name__ == '__main__':
    main()
