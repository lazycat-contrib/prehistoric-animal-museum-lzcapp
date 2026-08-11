# Prehistoric Animal Museum for LazyCat

This repository packages
[`s010s/prehistoric-animal-museum`](https://github.com/s010s/prehistoric-animal-museum)
as a LazyCat LPK. The upstream source is downloaded and built in GitHub Actions;
only the resulting static site is embedded in the LPK.

## Publish

Run **Build and publish LazyCat application** from the Actions tab. Each manual
run increments the patch version, creates a versioned GitHub Release asset, and
publishes the verified asset to the configured MiaoMiao private store.

Required GitHub Secrets:

- `APPSTORE_URL`
- `APPSTORE_TOKEN`

Optional GitHub Secrets:

- `APP_ID`
- `PRIVATE_STORE_GROUP_CODES`

Organization Secrets must explicitly authorize this repository. A Repository
Secret with the same name takes precedence over an Organization Secret.

## Local verification

```bash
./build.sh
lzc-cli project release -o .lazycat-build/prehistoric-animal-museum.lpk
lzc-cli lpk info .lazycat-build/prehistoric-animal-museum.lpk
```

The upstream project and bundled assets retain their original licenses and
attribution. See the notices embedded in the built application and the
[upstream licensing documentation](https://github.com/s010s/prehistoric-animal-museum/blob/main/LICENSING.md).
