import Image from 'next/image'

import cookieScreenshot from '../images/cookie.jpg'
import configScreenshot from '../images/config-screenshot.jpg'

const HowToGetMyCookie = () => (
  <section id="how-to-get-my-cookie">
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
      (if you are on asia/na/eu/sar) in <b>Chrome</b>, login, and press{' '}
      <kbd>F12</kbd> to open Chrome devtools.
    </p>

    <p>
      Navigate to <code>Console</code>, type in <code>document.cookie</code> and
      press <kbd>Enter</kbd>:
    </p>

    <figure>
      <Image src={cookieScreenshot} alt="Cookie screenshot" />
      <figcaption>Getting your cookie from 米游社 or HoYoLAB</figcaption>
    </figure>

    <p>
      Copy the string <i>without the quotes</i> and paste it inside{' '}
      <code>PaimonMenuBar</code> under{' '}
      <code>Preferences {'>'} Configuration</code>, and test your config:
    </p>

    <figure>
      <Image src={configScreenshot} alt="Config screenshot" />
      <figcaption>Putting your cookie in PaimonMenuBar</figcaption>
    </figure>

    <p>
      You should be able to see the updated data inside the app - which will
      periodically update if your config stays valid, enjoy!
    </p>
  </section>
)
export default HowToGetMyCookie
