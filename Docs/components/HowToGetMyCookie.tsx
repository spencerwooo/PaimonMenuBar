import Image from 'next/image'
import cookieScreenshot from '../images/cookie.png'
import configScreenshot from '../images/config-screenshot.png'

const HowToGetMyCookie = () => {
  return (
    <div id="how-to-get-my-cookie" className="w-full p-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-xl font-black mb-4">how to get my cookie?</h2>
        <p className="pb-4">
          open{' '}
          <a href="https://bbs.mihoyo.com/ys" target="_blank" rel="noopener noreferrer">
            bbs.mihoyo.com/ys
          </a>{' '}
          (if you are on 天空岛 or 世界树) or{' '}
          <a href="http://www.hoyolab.com/home" target="_blank" rel="noopener noreferrer">
            hoyolab.com/home
          </a>{' '}
          (if you are on asia/na/eu/sar) in chrome, login, and press <kbd>F12</kbd> to open chrome developer tools.
          navigate to <code>Console</code>, type in <code>document.cookie</code> and press <kbd>Enter</kbd>:
        </p>
        <Image src={cookieScreenshot} alt="Cookie screenshot" />
        <p className="pt-4">
          copy the string (without the quotes!) and paste it inside <code>PaimonMenuBar</code> under{' '}
          <code>Preferences {'>'} Configuration</code>, and test your config:
        </p>
        <Image src={configScreenshot} alt="Config screenshot" />
        <p className="pb-4">
          if successful, you should be able to see the updated data inside the app - which will periodically update if
          configuration stays valid, enjoy!
        </p>
      </div>
    </div>
  )
}
export default HowToGetMyCookie
