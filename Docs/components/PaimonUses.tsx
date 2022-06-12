import Image from 'next/image'
import zhongliThink from '../images/zhongli-think.png'

const PaimonUses = () => (
  <div>
    <Image
      className="float-right sticky top-4 hidden md:block"
      src={zhongliThink}
      alt="zhongli emoji"
      width={128}
      height={128}
      layout="raw"
    />

    <section className="prose prose-invert">
      <h2>How does Paimon work?</h2>
      <p>
        Paimon uses the official Mihoyo / Hoyoverse API found in either{' '}
        <a
          href="https://bbs.mihoyo.com/ys/"
          target="_blank"
          rel="noopener noreferrer"
        >
          米游社 (for CN players)
        </a>{' '}
        or{' '}
        <a
          href="https://www.hoyolab.com/home"
          target="_blank"
          rel="noopener noreferrer"
        >
          HoYoLAB (for Global players)
        </a>
        .
      </p>
    </section>
  </div>
)
export default PaimonUses
