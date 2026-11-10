# About
This is the source for the [RSMP Nordic website](https://rsmp-nordic.org).

It's a Jekyll site, hosted with GitHub Pages.

## Compliance collection

The collector stores run records on the `compliance-data` branch. Each collected
pair includes its GitHub `report_artifact_id`, so subsequent collections skip
downloading that immutable artifact. The workflow checks out these records on
each run; caching does not depend on files surviving on the runner.

New artifacts are merged into existing run records, preserving previously
collected pairs. Records without artifact IDs are downloaded again when they
fall within the collection window, then saved with their IDs. Failed downloads
are not cached. The collector's `--full` option ignores existing records and
downloads reports again within the configured lookback window.
