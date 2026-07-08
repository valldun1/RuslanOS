# Security Policy for RuslanOS

## Supported Versions

| Version | Supported |
|---------|-----------|
| v0.1.x (MVP) | ✅ Experimental |
| < v0.1 | ❌ |

## Reporting a Vulnerability

**RuslanOS is experimental software.** Do NOT use it on your primary device.

If you find a security vulnerability:

1. **Do NOT open a public GitHub Issue**
2. Contact the team via Telegram: @valldun1
3. Or email: security@ruslanos.team (if available)

We will respond within 48 hours.

## Known Security Considerations

- Ruslan Agent runs as **system app with root access** (via MagiskSU)
- All shell commands are executed with UID 0 (root)
- The device should NOT be used for banking or sensitive operations
- Lock Task Mode (kiosk) prevents app switching but is not bulletproof
- OTA updates are signed but the signing infrastructure is new

## Recommended Practices

1. Always install from official GitHub Releases
2. Verify checksums before flashing
3. Keep Magisk and the RuslanOS module updated
4. Do NOT install on devices with sensitive data
5. Use a dedicated device for testing
