import type { GetStaticProps } from 'next'
import type { AppReleaseData } from './types'
import Image from 'next/image'

import Features from '../components/Features'
import PaimonCan from '../components/PaimonCan'
import PaimonUses from '../components/PaimonUses'
import PaimonCookie from '../components/PaimonCookie'
import HowToGetMyCookie from '../components/HowToGetMyCookie'
import Footer from '../components/Footer'
import Hero from '../components/Hero'
import Meta from '../components/Head'

import hutaoBackground from '../images/hutao-bg.jpg'

const Home = ({ latest }: { latest: AppReleaseData }) => {
  return (
    <>
      <Meta />

      <div className="text-white relative">
        <div className="absolute w-full">
          <Image
            src={hutaoBackground}
            alt="background"
            placeholder="blur"
            layout="responsive"
            priority
          />
          <div className="absolute top-0 bottom-0 left-0 right-0 bg-gradient-to-b from-transparent to-[#2C3740]" />
        </div>

        <Hero latest={latest} />

        <Features />

        <div className="bg-[#2c3740] relative">
          <div className="max-w-5xl p-6 pt-24 mx-auto">
            <article className="space-y-16">
              <PaimonCan />
              <PaimonUses />
              <PaimonCookie />
              <HowToGetMyCookie />
            </article>
          </div>

          <Footer />
        </div>
      </div>
    </>
  )
}

export const getStaticProps: GetStaticProps = async () => {
  const resp = await fetch(
    'https://api.github.com/repos/spencerwooo/PaimonMenuBar/releases/latest'
  )
  const latest = (await resp.json()) as AppReleaseData
  return { props: { latest }, revalidate: 5 * 60 }
}

export default Home
