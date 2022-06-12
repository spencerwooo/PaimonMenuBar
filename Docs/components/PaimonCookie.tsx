import Image from 'next/image'
import luminePlease from '../images/lumine-please.png'

const PaimonCookie = () => (
  <div>
    <Image
      className="float-right sticky top-4 hidden md:block"
      src={luminePlease}
      alt="lumine emoji"
      width={128}
      height={128}
      layout="raw"
    />

    <section className="prose prose-invert">
      <h2>Why does Paimon need your cookie?</h2>
      <p>
        Cookies are sensitive information, and in some scenarios they function
        as your login credentials. Paimon requires your cookie so that Paimon
        can request said API on your behalf, and fetch those in-game stats
        periodically.
      </p>
      <p>
        Paimon will <b>never-ever-ever-ever</b> ask for your credentials to
        Genshin Impact nor any account! The cookie is{' '}
        <b>only stored locally.</b>
      </p>
    </section>
  </div>
)
export default PaimonCookie
