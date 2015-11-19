# A quine in Julia
using Codecs
the_string = "dXNpbmcgQ29kZWNzCnRoZV9zdHJpbmcgPSAiWCIKcHJpbnRsbihyZXBsYWNlKGJ5dGVzdHJpbmcoZGVjb2RlKEJhc2U2NCwgdGhlX3N0cmluZykpLCAiWCIsIHRoZV9zdHJpbmcsIDEpKQ=="
println(replace(bytestring(decode(Base64, the_string)), "X", the_string, 1))
