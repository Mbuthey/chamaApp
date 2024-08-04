import 'package:flutter/material.dart';

class PodCard extends StatelessWidget {
  const PodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: const Color(0xFF2E3B2F),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D5C9),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'SHAMBA LITERALS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '120k Ksh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://s3-alpha-sig.figma.com/img/83e8/bf5c/df60df089a75d36a266f421c90b4ad8b?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=VpvyRrC6q2B~DDRkTzwNHBqPgcS6uTQKsTsgVHFxxinCagiKrpwsrQObYoZ6LNYC77PnWWGhFKZc3VM8l8eOWfCP-rsOyqON70u4NJNN3e78fNIKitsSwza-Oui3rFDLa8eju4Ef0ptIXZ1j4YIF94EtGzTYOUPeo4DGp9WU16cLzboc160Y~42GkEApEAEzdpYU1aV7pRR1NJZbRUeqK1QpmY6q3Ltg8iCsD0PGRHjqfwC7PoJrGinAzknNY2ckAOG38uV0~8uTueNfxPNcgHZlBUDj8L4J3ddRnPnEnf2O6aH7r2m08VfNRI4uRhd7H~iXr0WzeoE4Gc6~~LV2Yw__'),
                ),
                const SizedBox(width: 8.0),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://s3-alpha-sig.figma.com/img/a3cd/31ff/7acedeca74155328d35dbcc16a799206?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=mCwouZaD0f~7MY8o0pMh9Sv8hOtElX7mxOfsTrDH-RwkmM8uCho3wiZHwmiB026qSxjjh-vOMSZgZnLwH1djDlkGEcuAp1xdZLNiG4Q67FzjBBmM4XUgNPPxPSvEJkKTQGILyehNwaV4UfoxLUfphqWscBBPjo1ZAyuemBbzPIR8YWd5u7YitygoPS0fPCprJH0~pQ4rp825KZK3ovF1Mgs7nuHX36rAMFJX0FcPNzk0u0YcgjtuwCFEZI~b4WDxyfK3igF7mBlipfnpwq78QHo6LdNTGtPMZKvDIWC4iXJKBPyIEL-DVomwHOhgMsl5Yr86Yr1zAfpdAK-Q9YTcFw__'),
                ),
                const SizedBox(width: 8.0),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://s3-alpha-sig.figma.com/img/ea8b/d106/f81809dc0d5485036ea82860b469cab0?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=c6tRHHROAVbiVZIIe5BTPomDrvEjFHPkmzHFa2Vmk-PwoIDNGe6x8enNKcaXkK4j3xf2kFMdlZB6yrtIKvPJwtwitCVOl0qFLAjWYPiSvZkgcMERA4sOHcQ2dUHWrRx2bKjaUenc6AY3QVfHMNdG3TNdlz4zluWBE67X6oa3wz4eqNWgacFdqvLj4VIKi9Zh-ARETpHxTGz2Zc6j0a-w5gbIskxcEjTe3CZAsg9QlSM-cSY8o-SGZBvGIURwALmEocDtgrpLvRb28K1MNUjaD6GJuHm66~jRFSaJF4xTfffsIuVr1GfqCy5k4iVw~cUkaWl~pHmhysWXKQMeceqz5w__'),
                ),
                const SizedBox(width: 8.0),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://s3-alpha-sig.figma.com/img/21bc/6568/8c6620fe6aea6df7aa1e0df506d55cc6?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fp6of6NX4uvGfsC7ALOZyRY-BHuLOY14t6acLxF36h1Ik-zStGlAyHqcTAp-U9u9fsEPKZz6UsAs8hJVDVuV2F~JelfduDIJYi7IyC9e7Zrl0Gct-OZMYqRmUsoyThwZuFB0~I7ART5e~xV5PUD2xKGcq9~C0a~8rKXTTVCbA0gIv74HPKTzG~QXIU7NQCoSo2ob-mcqv7b2PgwMiAhO6SG-8YIdsHfLAjw~8GWv~dL6lOsFejjRwXAZ8~B5DBDAtAP3ahRTq~JNnTtxlVkQwSDgl1DpOfZWac1dgOicJ-jOwvZj6umSjGrOBZt0wh6O4suD6YSkbnCX6qT2UQNltQ__'),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Due',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              '05/05/2024',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
