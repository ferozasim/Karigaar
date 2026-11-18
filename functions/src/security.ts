import {createHmac, timingSafeEqual} from "node:crypto";

export function hmacHex(secret: string, payload: Buffer, algorithm: "sha1" | "sha256" = "sha256"): string {
  return createHmac(algorithm, secret).update(payload).digest("hex");
}

export function constantTimeHexEqual(expected: string, provided: string): boolean {
  if (!/^[0-9a-f]+$/i.test(expected) || !/^[0-9a-f]+$/i.test(provided)) return false;
  const expectedBytes = Buffer.from(expected, "hex");
  const providedBytes = Buffer.from(provided, "hex");
  return expectedBytes.length === providedBytes.length && timingSafeEqual(expectedBytes, providedBytes);
}

export function verifyHmac(secret: string, payload: Buffer, provided: string, algorithm: "sha1" | "sha256" = "sha256"): boolean {
  return constantTimeHexEqual(hmacHex(secret, payload, algorithm), provided);
}
