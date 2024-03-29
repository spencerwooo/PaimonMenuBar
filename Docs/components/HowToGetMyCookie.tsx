import Image from "next/image"

import hutaoSleepy from '../images/hutao-sleepy.png'
import cookieScreenshot from '../images/cookie.jpg'
import configScreenshot from '../images/config-screenshot.jpg'

const HowToGetMyCookie = () => (
  <div>
    <Image
      className="float-right sticky top-4 hidden md:block"
      src={hutaoSleepy}
      alt="emoji hutao"
      width={128}
      height={128} />

    <section
      id="how-to-get-my-cookie"
      className="prose prose-invert prose-img:rounded prose-figcaption:text-center"
    >
      <h2>How to get my cookie?</h2>

      <p>
        Open{' '}
        <a
          href="https://bbs.mihoyo.com/ys"
          target="_blank"
          rel="noopener noreferrer"
        >
          https://bbs.mihoyo.com/ys
        </a>{' '}
        (if you are on 天空岛 or 世界树) or{' '}
        <a
          href="https://www.hoyolab.com/home"
          target="_blank"
          rel="noopener noreferrer"
        >
          https://hoyolab.com/home
        </a>{' '}
        (if you are on NA | EU | Asia | SAR) in <b>Chrome</b>, login, and press{' '}
        <kbd>F12</kbd> to open Chrome devtools.
      </p>

      <p>
        Navigate to <code>Console</code>, type in <code>document.cookie</code>{' '}
        and press <kbd>Enter</kbd>:
      </p>

      <figure>
        <Image
          src={cookieScreenshot}
          alt="Cookie screenshot"
          style={{
            maxWidth: "100%",
            height: "auto"
          }} />
        <figcaption>Getting your cookie from 米游社 or HoYoLAB</figcaption>
      </figure>

      <p>
        Copy the string <i>without the quotes</i> and paste it inside{' '}
        <code>PaimonMenuBar</code> under{' '}
        <code>Preferences {'>'} Configuration</code>, and test your config:
      </p>

      <figure>
        <Image
          src={configScreenshot}
          alt="Config screenshot"
          style={{
            maxWidth: "100%",
            height: "auto"
          }} />
        <figcaption>Putting your cookie in PaimonMenuBar</figcaption>
      </figure>

      <p>
        You should be able to see the updated data inside the app - which will
        periodically update if your config stays valid, enjoy!
      </p>
    </section>
  </div>
)
export default HowToGetMyCookie
