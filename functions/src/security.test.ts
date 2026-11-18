import assert from "node:assert/strict";
import {createHmac} from "node:crypto";
import {test} from "node:test";
import {constantTimeHexEqual, hmacHex, verifyHmac} from "./security.js";

test("HMAC verification accepts the signature for exact payload bytes", () => {
  const secret = "test-secret";
  const payload = Buffer.from('{"event":"payment.captured"}');
  const signature = createHmac("sha256", secret).update(payload).digest("hex");
  assert.equal(verifyHmac(secret, payload, signature), true);
});

test("HMAC verification rejects tampered payloads and signatures", () => {
  const payload = Buffer.from("original");
  const signature = hmacHex("test-secret", payload);
  assert.equal(verifyHmac("test-secret", Buffer.from("modified"), signature), false);
  assert.equal(verifyHmac("test-secret", payload, `${signature.slice(0, -2)}00`), false);
});

test("signature comparison rejects malformed and unequal-length hex values", () => {
  assert.equal(constantTimeHexEqual("abcd", "zzzz"), false);
  assert.equal(constantTimeHexEqual("abcd", "ab"), false);
});
